import EmberRouter from '@ember/routing/router';
import config from './config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('signup');
  this.route('login', { path: '/' });

  this.route('app', function () {
    this.route('dashboard');
    this.route('ticket');
    this.route('ticket_details', { path: '/ticket_details/:id' });
    this.route('create-ticket');
    this.route('update-ticket', { path: '/update_ticket/:id' });
  });
});
