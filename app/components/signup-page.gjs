import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { on } from '@ember/modifier';

export default class SignupPage extends Component {
  @service router;
  @service session;

  @tracked firstName = '';
  @tracked lastName = '';
  @tracked email = '';
  @tracked password = '';
  @tracked error = '';
  @tracked loading = false;

  @action updateFirst(e) {
    this.firstName = e.target.value;
  }

  @action updateLast(e) {
    this.lastName = e.target.value;
  }

  @action updateEmail(e) {
    this.email = e.target.value;
  }

  @action updatePassword(e) {
    this.password = e.target.value;
  }

  @action async handleSubmit(e) {
    e.preventDefault();
    this.error = '';

    if (!this.firstName || !this.lastName || !this.email || !this.password) {
      this.error = 'All fields are required.';
      return;
    }

    if (this.password.length < 6) {
      this.error = 'Password must be at least 6 characters.';
      return;
    }

    this.loading = true;
    await new Promise((r) => setTimeout(r, 800));

    this.session.login({
      email: this.email,
      name: `${this.firstName} ${this.lastName}`,
    });

    this.loading = false;
    this.router.transitionTo('dashboard');
  }

  @action goToLogin() {
    this.router.transitionTo('index');
  }

  <template>
    <div class="min-h-screen w-[500px] grid place-items-center bg-gray-100 px-4">
      <div class="w-full max-w-2xl bg-white shadow-2xl p-12 rounded-2xl">

        <h2 class="text-3xl font-bold text-center mb-6 text-indigo-700">
          Create an Account
        </h2>

        {{#if this.error}}
          <div class="mb-4 p-3 text-sm bg-red-100 text-red-700 rounded">
            {{this.error}}
          </div>
        {{/if}}

        <form {{on "submit" this.handleSubmit}} class="space-y-4">

          <div>
            <label class="block text-sm font-medium mb-1">First Name</label>
            <input
              type="text"
              value={{this.firstName}}
              {{on "input" this.updateFirst}}
              class="w-full border px-3 py-2 rounded focus:ring-2 focus:ring-indigo-400"
              placeholder="John"
            />
          </div>

          <div>
            <label class="block text-sm font-medium mb-1">Last Name</label>
            <input
              type="text"
              value={{this.lastName}}
              {{on "input" this.updateLast}}
              class="w-full border px-3 py-2 rounded focus:ring-2 focus:ring-indigo-400"
              placeholder="Doe"
            />
          </div>

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
            {{if this.loading "Creating..." "Sign Up"}}
          </button>
        </form>

        <p class="text-center text-sm mt-4 text-gray-600">
          Already have an account?
          <span
            class="text-indigo-600 font-medium hover:underline cursor-pointer"
            {{on "click" this.goToLogin}}
          >
            Login here
          </span>
        </p>

      </div>
    </div>
  </template>
}
