from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.ext.webapp import util
from google.appengine.ext.webapp import template
from google.appengine.ext.db import djangoforms
from django import forms

import os

from base import BaseHandler, QuizHandler
import links
from models import Quiz, Question, Score

class QuizForm(djangoforms.ModelForm):
    class Meta:
        model = Quiz
        exclude = ['updated']
    
    attempts = forms.IntegerField(
        min_value = 1,
        widget = forms.TextInput(attrs={'class': 'mini'})
    )
    
    title = forms.CharField(
        widget = forms.TextInput()
    )
        
class AddHandler(QuizHandler):    
    def get(self):
        self.values['form'] = QuizForm()
        self.values['action'] = links.Quiz.add()
        self.output('quiz_edit.html')
    
    def post(self):
        form = QuizForm(data=self.request.POST)
        self.values['form'] = form
        self.values['action'] = links.Quiz.add()
        
        if (form.is_valid()):
            quiz_entity = form.save()
            self.redirect(links.Quiz.edit(quiz_entity.key().id()))
        else:
            self.output('quiz_edit.html')

class EditHandler(QuizHandler):
    values = {
        'saved': True
    }
    
    def get(self, id):
        self.fetch(id)
        self.values['form'] = QuizForm(instance=self.quiz_entity)
        self.values['action'] = links.Quiz.edit(int(id))
        self.values['questions'] = Question.get_for_quiz(self.quiz_entity)
        self.output('quiz_edit.html')
        
    def post(self, id):
        self.fetch(id)
        form = QuizForm(data=self.request.POST, instance=self.quiz_entity)
        self.values['action'] = links.Quiz.edit(int(id))
        self.values['form'] = form
        
        if form.is_valid():
            quiz_entity = form.save(commit=False)
            quiz_entity.version += 1
            quiz_entity.put()
        
        self.output('quiz_edit.html')

class DeleteHandler(QuizHandler):
    def get(self, id):
        self.fetch(id)
        self.values['action'] = links.Quiz.delete(int(id))
        self.values['prompt'] = \
            'Are you absolutely sure that you would like to delete the ' \
            'quiz, "%s," forever?' % self.quiz_entity.title 
        self.values['back'] = os.environ['HTTP_REFERER']
        self.output('confirm.html')
    
    def post(self, id): 
        self.fetch(id)
        self.quiz_entity.is_deleting = True
        self.quiz_entity.put()
        
        # TODO: Delete quiz, questions, attempts, scores, attempts, snapshots
        
        self.redirect('/')

class RosterHandler(QuizHandler):
    def get(self, id):
        self.fetch(id)
        
        scores_query = Score.all()
        scores_query.filter('quiz =', self.quiz_entity)
        scores_query.order('last_name')
        self.values['scores'] = scores_query.fetch(100)
        
        self.output('quiz_roster.html')

def main():
    application = webapp.WSGIApplication([
        ('/quiz/add', AddHandler),
        (r'/quiz/edit/(.*)', EditHandler),
        (r'/quiz/delete/(.*)', DeleteHandler),
        (r'/quiz/roster/(.*)', RosterHandler)
    ], debug=True)
    util.run_wsgi_app(application)

if __name__ == '__main__':
    main()