/**
 * jsPsych plugin for pavlovia.org
 *
 * This plugin handles communications with the pavlovia.org server: it opens and closes sessions,
 * and uploads data to the server.
 *
 * @author Alain Pitiot
 * @version 3.2.5
 * @copyright (c) 2019 Ilixa Ltd. ({@link http://ilixa.com})
 * @license Distributed under the terms of the MIT License
 */


jsPsych.plugins['pavlovia'] = (function() {

	/**
	 * The version number.
	 *
	 * @type {string}
	 * @public
	 */
	const version = '3.2.5';


	let plugin = {};


	/**
	 * The default error callback function.
	 *
	 * Error messages are displayed in the body of the document and in the browser's console.
	 *
	 * @param {Object} error - the error json object to be displayed.
	 * @public
	 */
	const defaultErrorCallback = function(error)
	{
		// output the error to the console:
		console.error('[pavlovia ' + version + ']', error);

		// output the error to the html body:
		let htmlCode = '<h3>[jspsych-pavlovia plugin ' + version + '] Error</h3><ul>';
		while (true) {
			if (typeof error === 'object' && 'context' in error) {
				htmlCode += '<li>' + error.context + '</li>';
				error = error.error;
			} else {
				htmlCode += '<li><b>' + error  + '</b></li>';
				break;
			}
		}
		htmlCode += '</ul>';
		document.querySelector('body').innerHTML = htmlCode;
	};


	/**
	 * Plugin information.
	 * @public
	 */
	plugin.info = {
		name: 'pavlovia',
		description: 'communication with pavlovia.org',
		parameters: {
			command: {
				type: jsPsych.plugins.parameterType.STRING,
				pretty_name: 'Command',
				default: 'init',
				description: 'The pavlovia command: "init" (default) or "finish"'
			},
			participantId: {
				type: jsPsych.plugins.parameterType.STRING,
				pretty_name: 'Participant Id',
				default: 'PARTICIPANT',
				description: 'The participant Id: "PARTICIPANT" (default) or any string'
			},
			errorCallback: {
				type: jsPsych.plugins.parameterType.FUNCTION,
				pretty_name: 'ErrorCallback',
				default: defaultErrorCallback,
				description: 'The callback function called whenever an error has occurred'
			}
		}
	};


	/**
	 * Run the plugin.
	 *
	 * @param {HTMLElement} display_element - the HTML DOM element where jsPsych content is rendered
	 * @param {Object} trial - the jsPsych trial
	 * @public
	 */
	plugin.trial = function(display_element, trial)
	{

		// execute the command:
		switch (trial.command.toLowerCase()) {
			case 'init':
				_init(trial);
				break;

			case 'finish':
				let data = jsPsych.data.get().csv();
				_finish(trial, data);
				break;

			default:
				trial.errorCallback('unknown command: ' + trial.command);
		}


		// end trial
		jsPsych.finishTrial();
	};


	/**
	 * The pavlovia.org configuration (usually read from the config.json configuration file).
	 *
	 * @type {Object}
	 * @private
	 */
	let _config = {};


	/**
	 * The server paramaters (those starting with a double underscore).
	 * @type {Object}
	 * @private
	 */
	let _serverMsg = new Map();


	/**
	 * Initialise the connection with pavlovia.org: configure the plugin and open a new session.
	 *
	 * @param {Object} trial - the jsPsych trial
	 * @param {string} [configURL= "config.json"] - the URL of the pavlovia.org json configuration file
	 * @returns {Promise<void>}
	 * @private
	 */
	const _init = async function(trial, configURL = 'config.json')
	{
		try {
			// configure:
			let response = await _configure(configURL);
			_config = response.config;
			_log('init | configure.response=', response);

			// open a new session:
			response = await _openSession();
			_config.experiment.token = response.token;
			_log('init | openSession.response=', response);

			// attempt to close the session on beforeunload/unload:
			// note: we use a synchronous request since the Beacon API only allows POST and we need DELETE
			window.onbeforeunload = () => {
				// close the session synchronously:
				_closeSession(false, true);
			};
			window.addEventListener('unload', function(event) {
				// close the session synchronously:
				_closeSession(false, true);
			});

		} catch (error) {
			trial.errorCallback(error);
		}
	};


	/**
	 * Finish the connection with pavlovia.org: upload the collected data and close the session.
	 *
	 * @param {Object} trial - the jsPsych trial
	 * @param {Object} data - the experiment data to be uploaded
	 * @returns {Promise<void>}
	 * @private
	 */
	const _finish = async function(trial, data)
	{
		try {
			// upload the data to pavlovia.org:
			const date = new Date();
			let dateString = date.getFullYear() + '-' + ('0'+(1+date.getMonth())).slice(-2) + '-' + ('0'+date.getDate()).slice(-2) + '_';
			dateString += ('0'+date.getHours()).slice(-2) + 'h' + ('0'+date.getMinutes()).slice(-2) + '.' + ('0'+date.getSeconds()).slice(-2) + '.' + date.getMilliseconds();

			const key = _config.experiment.name + '_' + trial.participantId + '_' + 'SESSION' + '_' + dateString + '.csv';
			let response = await _uploadData(key, data);
			_log('finish | uploadData.response=', response);

			// close the session:
			response = await _closeSession();
			_log('finish | closeSession.response=', response);
		} catch (error) {
			trial.errorCallback(error);
		}
	};


	/**
	 * Configure the plugin by reading the configuration file created upon activation of the experiment.
	 *
	 * @param {string} [configURL= "config.json"] - the URL of the pavlovia.org json configuration file
	 * @returns {Promise<any>}
	 * @private
	 */
	const _configure = async function(configURL)
	{
		let response = { origin: '_configure', context: 'when configuring the plugin' };

		try {
			const configurationResponse = await _getConfiguration(configURL);

			// legacy experiments had a psychoJsManager block instead of a pavlovia block, and the URL
			// pointed to https://pavlovia.org/server
			if ('psychoJsManager' in configurationResponse.config) {
				delete configurationResponse.config.psychoJsManager;
				configurationResponse.config.pavlovia = {
					URL: 'https://pavlovia.org'
				};
			}

			// tests for the presence of essential blocks in the configuration:
			if (!('experiment' in configurationResponse.config))
				throw 'missing experiment block in configuration';
			if (!('name' in configurationResponse.config.experiment))
				throw 'missing name in experiment block in configuration';
			if (!('fullpath' in configurationResponse.config.experiment))
				throw 'missing fullpath in experiment block in configuration';
			if (!('pavlovia' in configurationResponse.config))
				throw 'missing pavlovia block in configuration';
			if (!('URL' in configurationResponse.config.pavlovia))
				throw 'missing URL in pavlovia block in configuration';


			// get the server parameters (those starting with a double underscore):
			const urlQuery = window.location.search.slice(1);
			const urlParameters = new URLSearchParams(urlQuery);
			urlParameters.forEach((value, key) => {
				if (key.indexOf('__') === 0)
					_serverMsg.set(key, value);
			});


			return configurationResponse;
		}
		catch (error) {
			throw { ...response, error };
		}
	};


	/**
	 * Get the pavlovia.org json configuration file.
	 *
	 * @param {string} configURL - the URL of the pavlovia.org json configuration file
	 * @returns {Promise<any>}
	 * @private
	 */
	const _getConfiguration = function(configURL)
	{
		let response = { origin: '_getConfiguration', context: 'when reading the configuration file: ' + configURL };

		return new Promise((resolve, reject) => {
			$.get(configURL, 'json')
				.done((config, textStatus) => {
					resolve({ ...response, config });
				})
				.fail((jqXHR, textStatus, errorThrown) => {
					reject({ ...response, error: errorThrown });
				});
		});
	};


	/**
	 * Open a new session for this experiment on pavlovia.org.
	 *
	 * @returns {Promise<any>}
	 * @private
	 */
	const _openSession = function()
	{
		let response = { origin: '_openSession', context: 'when opening a session for experiment: ' + _config.experiment.fullpath };

		// prepare POST query:
		let data = {};
		if (_serverMsg.has('__pilotToken'))
			data.pilotToken = _serverMsg.get('__pilotToken');

		// query pavlovia server:
		const self = this;
		return new Promise((resolve, reject) => {
			$.post(_config.pavlovia.URL + '/api/v2/experiments/' + encodeURIComponent(_config.experiment.fullpath) + '/sessions', data, null, 'json')
				.done((data, textStatus) => {
					// check for required attributes:
					if (!('token' in data)) {
						reject(Object.assign(response, { error: 'unexpected answer from server: no token'}));
					}
					if (!('experiment' in data)) {
						reject(Object.assign(response, { error: 'unexpected answer from server: no experiment'}));
					}

					// update the configuration:
					_config.experiment.status = data.experiment.status2;
					_config.experiment.saveFormat = Symbol.for(data.experiment.saveFormat);
					_config.session = { token: data.token };

					resolve(Object.assign(response, { token: data.token, status: data.status }));
				})
				.fail((jqXHR, textStatus, errorThrown) => {
					console.log('error:', jqXHR.responseText);
					reject(Object.assign(response, { error: jqXHR.responseJSON }));
				});
		});

	};


	/**
	 * Close the previously opened session on pavlovia.org.
	 *
	 * @returns {Promise<any>}
	 * @private
	 */
	const _closeSession = function(isCompleted = true, sync = false)
	{
		let response = { origin: '_closeSession', context: 'when closing the session for experiment: ' + _config.experiment.fullpath };

		// prepare DELETE query:
		const url = _config.pavlovia.URL + '/api/v2/experiments/' + encodeURIComponent(_config.experiment.fullpath) + '/sessions/' + _config.session.token;
		const data = { isCompleted };

		// synchronous query the pavlovia server:
		if (sync)
		{
			const request = new XMLHttpRequest();
			request.open("DELETE", url, false);
			request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
			request.send(JSON.stringify(data));

			return;
		}

		// asynchronously query the pavlovia server:
		return new Promise((resolve, reject) => {
			$.ajax({
				url,
				type: 'delete',
				data,
				dataType: 'json'
			})
			.done((data, textStatus) => {
				resolve(Object.assign(response, { data }));
			})
			.fail((jqXHR, textStatus, errorThrown) => {
				console.error('error:', jqXHR.responseText);
				reject(Object.assign(response, { error: jqXHR.responseJSON }));
			});
		});

	};


	/**
	 * Upload data (a key/value pair) to pavlovia.org.
	 *
	 * @param {string} key - the key
	 * @param {Object} value - the value
	 * @returns {Promise<any>}
	 * @private
	 */
	const _uploadData = function(key, value)
	{
		let response = { origin: '_uploadData', context: 'when uploading participant\' results for experiment: ' + _config.experiment.fullpath };


		// prepare the POST query:
		const data = {
			key,
			value
		};

		// query the pavlovia server:
		return new Promise((resolve, reject) => {
			const url = _config.pavlovia.URL + '/api/v2/experiments/' + encodeURIComponent(_config.experiment.fullpath) + '/sessions/' + _config.session.token + '/results';
			$.post(url, data, null, 'json')
				.done((serverData, textStatus) => {
					resolve(Object.assign(response, { serverData }));
				})
				.fail((jqXHR, textStatus, errorThrown) => {
					console.error('error:', jqXHR.responseText);
					reject(Object.assign(response, { error: jqXHR.responseJSON }));
				});
		});

	};


	/**
	 * Log messages to the browser's console.
	 *
	 * @param {...*} messages - the messages to be displayed in the browser's console
	 * @private
	 */
	const _log = function(...messages) {
		console.log('[pavlovia ' + version + ']', ...messages);
	};


	return plugin;
})();
