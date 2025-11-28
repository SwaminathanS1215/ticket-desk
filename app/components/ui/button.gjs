import Component from '@glimmer/component';
import { action } from '@ember/object';
import { or } from '@ember/helper';

export default class AppButton extends Component {
  get baseClasses() {
    return 'inline-flex items-center justify-center font-semibold rounded-md transition focus:outline-none focus:ring-2 focus:ring-offset-2';
  }

  get variantClasses() {
    switch (this.args.variant) {
      case 'secondary':
        return 'bg-purple-600 text-white hover:bg-purple-700';
      case 'danger':
        return 'bg-red-600 text-white hover:bg-red-700';
      case 'outline':
        return 'border border-blue-600 text-blue-600 bg-transparent hover:bg-blue-50';
      default:
        return 'bg-blue-600 text-white hover:bg-blue-700'; // primary
    }
  }

  get sizeClasses() {
    switch (this.args.size) {
      case 'sm':
        return 'px-3 py-1 text-sm';
      case 'lg':
        return 'px-6 py-3 text-lg';
      default:
        return 'px-4 py-2 text-base'; // md
    }
  }

  get fullWidthClass() {
    return this.args.fullWidth ? 'w-full' : '';
  }

  get disabledClass() {
    return this.args.disabled || this.args.loading ? 'opacity-60 cursor-not-allowed' : '';
  }

  get classes() {
    return [
      this.baseClasses,
      this.variantClasses,
      this.sizeClasses,
      this.fullWidthClass,
      this.disabledClass,
      this.args.class,
    ].join(' ');
  }

  @action
  handleClick(e) {
    if (this.args.disabled || this.args.loading) return;
    this.args.onClick?.(e);
  }

  <template>
    <button
      type="button"
      class={{this.classes}}
      disabled={{or this.args.disabled this.args.loading}}
      {{on "click" this.handleClick}}
    >
      {{#if this.args.loading}}
        <svg
          class="animate-spin h-4 w-4 mr-2 text-white"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
        >
          <circle
            class="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            stroke-width="4"
          />
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z" />
        </svg>
      {{/if}}

      {{yield}}
    </button>
  </template>
}
