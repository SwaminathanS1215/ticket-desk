import Controller from '@ember/controller';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';

export default class LoginController extends Controller {
  @service auth;
  @service router;

  error = '';

  @action
  async login(payload) {
    this.error = '';
    try {
      await this.auth.login(payload.email, payload.password);
      this.router.transitionTo('app.dashboard');
    } catch (e) {
      this.error = e.message || 'Login failed';
      throw e;
    }
  }
}
