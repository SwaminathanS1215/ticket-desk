import Route from '@ember/routing/route';

export default class SignupRoute extends Route {
  model() {
    return {
      name: '',
      email: '',
      password: '',
      role: '',
    };
  }
}
