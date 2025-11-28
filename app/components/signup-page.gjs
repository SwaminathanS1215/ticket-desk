import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { service } from '@ember/service';

export default class SignupPage extends Component {
  @service router;

  @tracked form = { ...this.args.formData };

  @tracked errors = {};
  @tracked loading = false;

  @action updateField(field, e) {
    this.form = { ...this.form, [field]: e.target.value };
    this.errors = { ...this.errors, [field]: '' };
  }

  validate() {
    let errors = {};

    if (!this.form.name.trim()) errors.name = 'Name is required';
    if (!this.form.email.trim()) errors.email = 'Email is required';
    if (!this.form.role.trim()) errors.agent = 'Role is required';
    if (!this.form.password.trim()) errors.password = 'Password is required';
    else if (this.form.password.length < 6)
      errors.password = 'Password must be at least 6 characters';

    this.errors = errors;
    return Object.keys(errors).length === 0;
  }

  @action async handleSubmit(e) {
    e.preventDefault();
    if (!this.validate()) return;

    this.loading = true;

    try {
      await this.args.onSubmit(this.form);
    } catch (error) {
      this.errors = { general: error.message || 'Signup failed' };
    }

    this.loading = false;
  }

  @action goToLogin() {
    this.router.transitionTo('/');
  }

  <template>
    <div class="min-h-screen w-[500px] grid place-items-center bg-gray-100 px-4">
      <div class="w-full max-w-2xl bg-white shadow-2xl p-12 rounded-2xl">

        <h2 class="text-3xl font-bold text-center mb-6 text-indigo-700">
          Create an Account
        </h2>

        {{#if this.errors.general}}
          <div class="mb-4 p-3 text-sm bg-red-100 text-red-700 rounded">
            {{this.errors.general}}
          </div>
        {{/if}}

        <form {{on "submit" this.handleSubmit}} class="space-y-4">
          <div>
            <label class="block text-sm font-medium mb-1">Name *</label>
            <input
              type="text"
              value={{this.form.name}}
              {{on "input" (fn this.updateField "name")}}
              class="w-full border px-3 py-2 rounded {{if this.errors.name 'border-red-500'}}"
              placeholder="John Doe"
            />
            {{#if this.errors.name}}
              <p class="text-xs text-red-600 mt-1">{{this.errors.name}}</p>
            {{/if}}
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Email *</label>
            <input
              type="email"
              value={{this.form.email}}
              {{on "input" (fn this.updateField "email")}}
              class="w-full border px-3 py-2 rounded {{if this.errors.email 'border-red-500'}}"
              placeholder="you@example.com"
            />
            {{#if this.errors.email}}
              <p class="text-xs text-red-600 mt-1">{{this.errors.email}}</p>
            {{/if}}
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Role *</label>
            <input
              type="text"
              value={{this.form.role}}
              {{on "input" (fn this.updateField "role")}}
              class="w-full border px-3 py-2 rounded {{if this.errors.role 'border-red-500'}}"
              placeholder="Role"
            />
            {{#if this.errors.role}}
              <p class="text-xs text-red-600 mt-1">{{this.errors.role}}</p>
            {{/if}}
          </div>
          <div>
            <label class="block text-sm font-medium mb-1">Password *</label>
            <input
              type="password"
              value={{this.form.password}}
              {{on "input" (fn this.updateField "password")}}
              class="w-full border px-3 py-2 rounded {{if this.errors.password 'border-red-500'}}"
              placeholder="••••••••"
            />
            {{#if this.errors.password}}
              <p class="text-xs text-red-600 mt-1">{{this.errors.password}}</p>
            {{/if}}
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
