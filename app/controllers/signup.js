import Controller from '@ember/controller';
import { service } from '@ember/service';
import { action } from '@ember/object';

export default class SignupController extends Controller {
  @service auth;
  @service router;

  error = '';

  @action async signup(payload) {
    this.error = '';
    try {
      await this.auth.signup(payload);
      this.router.transitionTo('/');
    } catch (e) {
      this.error = e.message || 'Signup failed';
      throw e;
    }
  }
}
