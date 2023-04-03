# Django Toturial
This is a toturial for Django. This are created to demonstrate django's basic features.

## Project and App
Project can contain many apps. Usually, one project is one website. One app is one part of the website. For example, a blog website can have a blog app and a comment app. For example,Facebook, users is in one app, and facebook group is in another app. But, Facebook is one project.
### Project Structure
```bash
├── README.md
├── manage.py
├── PROJECT_NAME
├── App1
├── App2
├── App3
├    |── templates (define html templates)
├    |── static (define static files)
├    ├── models.py (define databaes structure)
├    ├── views.py (define views)
├    ├── urls.py (define url patterns)
├    ├── admin.py (define admin interface)
├    ├── tests.py (define test cases)
├    └── migrations (define database migration)
└── ...
```

### Development, Staging, and Production

#### Development
```bash
$ python manage.py runserver
```
#### Staging
in the staging environment, you’ll want to use a different database, and you’ll want to collect all the static files into a single location that can be served by a web server. In this case we'll use docker-compose to build a staging environment.
```bash
$ docker-compose up
```
the docker-compose.yml file is defined as:
```yaml
version: '3.1'
services:
  db:
    image: postgres
    volumes:
      - ./db:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
      POSTGRES_DB: postgres
  web:
    build: .
    command: python manage.py runserver
    environment:
      - ENV: docker
```
and in the settings.py file, the database is defined as:

```python
DATABASES = {
    "default": {
        'ENGINE': 'django.db.backends.postgresql',
    },
    'OPTIONS': {
            'service': 'my_service',
            'passfile': '.my_pgpass',
        },
}
```



#### Production
AWS Elastic Beanstalk is a service for deploying and scaling web applications and services developed with Java, .NET, PHP, Node.js, Python, Ruby, Go, and Docker on familiar servers such as Apache, Nginx, Passenger, and IIS. It provides a one-click deployment environment that automates the process of configuring and scaling your application. It also provides a dashboard that gives you access to the metrics of your application.
##### Database
AWS Elastic Beanstalk supports the following database engines:
- Amazon Aurora
- [Amazon RDS](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-rds.html)
##### Deployment
AWS Elastic Beanstalk supports the following deployment methods:
- [CodeCommit](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-codecommit.html)
- [CodeDeploy](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-codedeploy.html)
- [CodePipeline](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-codepipeline.html)
- [Elastic Beanstalk CLI](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-eb-cli.html)

## Models
Models are the single, definitive source of information about your data. It contains the essential fields and behaviors of the data you’re storing. Generally, each model maps to a single database table.
A model could contain many fields, it's own method, adminstration options, and metadata. Each field is represented by an instance of a Field class – e.g., CharField for character fields and DateTimeField for datetimes. This tells Django what type of data each field holds.

### Registering Models
After creating a model, you need to tell Django you’re going to use that model. You do this by editing the INSTALLED_APPS setting in your project’s settings.py file. You need to add the name of the app that contains the model. For example, if your model is defined in a file called models.py in the polls app, you’d add 'polls.apps.PollsConfig' to the INSTALLED_APPS setting.
```python
INSTALLED_APPS = [
    'polls.apps.PollsConfig',
    ...
]
```
### Activating Models
Once you’ve made changes to your models (in models.py), you’ll need to tell Django you’ve made some changes. Run the following command:
```bash
$ python manage.py makemigrations polls
```
This command looks at the models you’ve defined in polls/models.py and creates migrations for those changes. It doesn’t touch your database at all – it just creates migration files on your disk. You can read the migration files if you like; they’re just Python files.
### Migrate
Now that you have some migrations, you can apply them to your database. Run the following command:
```bash
$ python manage.py migrate
```

## Views <sup>*controllers*<sup>
A views (eg. [./polls/view.py](./polls/views.py)) is a collective of render function bound by [./polls/urls.py](./polls/urls.py). A view is responsible for returning an HTTP response. It can be a simple function, or a class-based view. A view function, or view for short, is simply a Python function that takes a Web request and returns a Web response. This response can be the HTML contents of a Web page, or a redirect, or a 404 error, or an XML document, or an image . . . or anything, really. The view itself contains whatever arbitrary logic is necessary to return that response.
### Generic Views
Django provides a set of generic views (e.g. ListView) that do most of the work for you and are configured via declarative parameters. For example, to display a list of objects, you can use the ListView generic view instead of writing your own view. This approach is cleaner and more efficient. It’s also easier to reuse code, because the same view can be used in multiple URLs.

Examples

ListView would display a list of objects that was defined in the model.
```python
class IndexView(generic.ListView):
    template_name = 'polls/index.html'
    context_object_name = 'latest_question_list'

    def get_queryset(self):
        """Return the last five published questions."""
        return Question.objects.order_by('-pub_date')[:5]
```

DetailView would display a detail page for a particular type of object.
```python
class DetailView(generic.DetailView):
    model = Question
    template_name = 'polls/detail.html'
```
The DetailView generic view expects the primary key value captured from the URL to be called "pk", so we’ve changed question_id to pk for the generic views.

The PK parameter would generally be defined in URL, for example, in [./polls/urls.py](./polls/urls.py), the URL pattern is defined as:
```python
path('<int:pk>/', views.DetailView.as_view(), name='detail'),
``` 
### Template
A template is a text file that Django will fill with data before sending it to the user. A template can be any text file, but Django templates have a specific syntax and extension. The default extension is .html, but you can use any extension you like. The template system is designed to allow you to use any text-based template language you like, but Django comes with a built-in template language that’s easy to learn and understand.

### Template Context
A context is a dictionary mapping template variable names to Python objects. When a template is rendered with a context, it replaces any variable names with the given values. For example, if you have a template that looks like this:
```html
<p>My name is {{ name }}.</p>
```
and you render it with a context that has a name value of 'Adrian', the template will be changed to:
```html
<p>My name is Adrian.</p>
```
## Admin
Django provided an admin interface that you can use to create, view, update, and delete your models. This is a powerful tool that you can use to manage your site without having to write any code. You can also use the admin to create new users and assign permissions to them.

### Superuser
To access the admin site, you need to create a user account and log in.

To create a user account, call the createsuperuser management command. This command prompts you for a username, an email address, and a password. Once you enter all those values, the user account is created.
```bash
$ python manage.py createsuperuser
```
easy.

## Database
Django supports all major **relational databases**: PostgreSQL, MySQL, SQLite, and Oracle. It also provides built-in support for non-relational databases, such as Google’s Datastore and MongoDB. Which would be configured in [./PROJECT_NAME/settings.py](./PROJECT_NAME/settings.py).
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```
## Authentication
Django provides a **authentication system** that handles users’ accounts and permissions. It can handle anything from a small personal site to a large corporate intranet. The authentication system consists of:
- A **data model** that stores information about users.
- A **set of views** that let users to create and edit their accounts.
- A **set of templates** that are used by the built-in views.
- A **set of forms** that let users log in and change their password.
- A **set of backends** that let you authenticate against different sources, such as Active Directory, LDAP, or Google’s authentication service.
- A **set of middleware** that lets you restrict access to parts of your site based on a user’s authentication status.
### Supported authentication backends
- [django.contrib.auth.backends.ModelBackend](https://docs.djangoproject.com/en/1.11/ref/contrib/auth/#django.contrib.auth.backends.ModelBackend)
    - This is the default authentication backend. It authenticates against the User model that’s defined in django.contrib.auth.models.
- [django.contrib.auth.backends.RemoteUserBackend](https://docs.djangoproject.com/en/1.11/ref/contrib/auth/#django.contrib.auth.backends.RemoteUserBackend)
    - This authentication backend is useful if you’re running Django behind a Web server that handles authentication. For example, if you’re running Django on Apache with mod_python or mod_wsgi, you can configure Apache to handle authentication, and then use this backend to tell Django to trust the authentication header that Apache passes to it.
- [django.contrib.auth.backends.AllowAllUsersModelBackend](https://docs.djangoproject.com/en/1.11/ref/contrib/auth/#django.contrib.auth.backends.AllowAllUsersModelBackend)
    - This authentication backend is useful if you want to allow all users to log in, without needing to create a User object for each of them. It’s useful for development, but not recommended for production.
- [django.contrib.auth.backends.AllowAllUsersRemoteUserBackend](https://docs.djangoproject.com/en/1.11/ref/contrib/auth/#django.contrib.auth.backends.AllowAllUsersRemoteUserBackend)
    - This authentication backend is useful if you want to allow all users to log in, without needing to create a User object for each of them. It’s useful for development, but not recommended for production.
### ModelBackend
This is the default authentication backend. It authenticates against the User model that’s defined in django.contrib.auth.models.
#### Defining a custom user model
If you want to customize the User model, you can do so by creating a custom model that subclasses AbstractUser, then setting AUTH_USER_MODEL to point to your custom user model. For example, if you want to add an extra field to the User model, you can create a custom model like this:
```python
from django.contrib.auth.models import AbstractUser

class CustomUser(AbstractUser):
    age = models.PositiveIntegerField(null=True, blank=True)
    ...
```
Then, in your settings.py file, set AUTH_USER_MODEL to point to your custom user model:
```python
AUTH_USER_MODEL = 'users.CustomUser'
```


# References
- [Django Tutorial](https://docs.djangoproject.com/en/1.11/intro/tutorial01/)

# TODO
- [ ] Authentication
- [ ] Sessions
- [ ] Messages
- [ ] Signals
- [ ] [Components](https://pypi.org/project/django-components/)
- [ ] [Django REST framework](https://www.django-rest-framework.org/)
- [ ] Add more todo items