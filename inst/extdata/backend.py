import os
import urllib

from google.appengine.api import users
from google.appengine.ext import ndb

import jinja2
import webapp2

JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
    extensions=['jinja2.ext.autoescape'])

import cgi
import urllib

#from google.appengine.api import users
from google.appengine.ext import ndb

import webapp2

class DataObject(ndb.Model):
    """Models an individual Guestbook entry with author, content, and date."""
    content = ndb.TextProperty(required=True) # defaults to non-indexed
    date = ndb.DateTimeProperty(auto_now_add=True, indexed=False)


class MainPage(webapp2.RequestHandler):

    def get(self):
        template = JINJA_ENVIRONMENT.get_template('index.html')
        self.response.write(template.render())

class WriteDataObject(webapp2.RequestHandler):

    def post(self):
        data = DataObject()

        data.content = self.request.get('content')
        data.exp = self.request.get('exp')
        data.put()


application = webapp2.WSGIApplication([
    ('/', MainPage),
    ('/submit', WriteDataObject),
], debug=True)
