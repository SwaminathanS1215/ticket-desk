import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { on } from '@ember/modifier';

export default class LoginPage extends Component {
  @service router;
  @service session;

  @tracked email = '';
  @tracked password = '';
  @tracked loading = false;
  @tracked error = '';

  // input handlers
  @action updateEmail(e) {
    this.email = e.target.value;
  }

  @action updatePassword(e) {
    this.password = e.target.value;
  }

  // LOGIN SUBMIT
  @action async handleSubmit(e) {
    e.preventDefault();
    this.error = '';

    if (!this.email || !this.password) {
      this.error = 'Email and password are required.';
      return;
    }

    this.loading = true;

    // Fake API call
    await new Promise((r) => setTimeout(r, 700));

    this.session.login({ email: this.email }); // store session user
    this.loading = false;

    this.router.transitionTo('dashboard');
  }

  // navigate to signup
  @action goToSignup() {
    this.router.transitionTo('signup');
  }

  <template>
    <div class="min-h-screen w-[500px] grid place-items-center bg-gray-100 px-4">
      <div class="w-full max-w-2xl bg-white shadow-2xl p-12 rounded-2xl">

        <h2 class="text-2xl font-bold text-center mb-6 text-indigo-700">
          Login
        </h2>

        {{#if this.error}}
          <div class="mb-4 p-3 text-sm bg-red-100 text-red-700 rounded">
            {{this.error}}
          </div>
        {{/if}}

        <form {{on "submit" this.handleSubmit}} class="space-y-4">

          <div>
            <label class="block text-sm font-medium mb-1">Email</label>
            <input
              type="email"
              value={{this.email}}
              {{on "input" this.updateEmail}}
              class="w-full border px-3 py-2 rounded focus:ring-2 focus:ring-indigo-400"
              placeholder="you@example.com"
            />
          </div>

          <div>
            <label class="block text-sm font-medium mb-1">Password</label>
            <input
              type="password"
              value={{this.password}}
              {{on "input" this.updatePassword}}
              class="w-full border px-3 py-2 rounded focus:ring-2 focus:ring-indigo-400"
              placeholder="••••••••"
            />
          </div>

          <button
            type="submit"
            class="w-full bg-indigo-600 hover:bg-indigo-700 text-white py-2 rounded font-medium"
          >
            {{if this.loading "Logging in..." "Login"}}
          </button>
        </form>

        <p class="text-center text-sm mt-4 text-gray-600">
          Don’t have an account?
          <span
            class="text-indigo-600 font-medium hover:underline cursor-pointer"
            {{on "click" this.goToSignup}}
          >
            Create one here
          </span>
        </p>

      </div>
    </div>
  </template>
}
