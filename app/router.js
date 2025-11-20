import EmberRouter from '@ember/routing/router';
import config from './config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('signup');
  this.route('index', { path: '/' });

  this.route('app', function () {
    this.route('dashboard');
    this.route('ticket');
  });
});
