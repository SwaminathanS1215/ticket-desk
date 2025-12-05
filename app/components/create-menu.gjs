import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { modifier } from 'ember-modifier';
import { CreateIcon, TicketLargeIcon } from '../utils/icons';
import clickOutside from 'ticket-desk/modifiers/click-outside.js';

export default class CreateMenu extends Component {
  @service createMenu;
  @service router;

  CreateIcon = CreateIcon;
  TicketLargeIcon = TicketLargeIcon;

  @tracked rotationDegrees = 0;

  @action
  rotateIcon() {
    this.rotationDegrees += 90;
  }

  @action
  toggleMenu() {
    this.createMenu.toggle();
  }

  @action
  openCreateTicket() {
    this.createMenu.close();
    this.router.transitionTo('app.create-ticket');
  }

  applyRotation = modifier((element) => {
    element.style.transform = `rotate(${this.rotationDegrees}deg)`;
  });
  @action
  handleClickOutside() {
    this.createMenu.close();
  }

  <template>
    <div class="relative" {{clickOutside this.handleClickOutside condition=this.createMenu.open}}>
      <button
        type="button"
        class="w-7 h-7 shadow-lg flex items-center justify-center rounded-full bg-blue-600 hover:bg-blue-700 shadow text-white cursor-pointer transition"
        {{on "click" this.toggleMenu}}
        {{on "mouseenter" this.rotateIcon}}
      >
        <div
          class="inline-block transition-transform duration-300 ease-in-out"
          {{this.applyRotation}}
        >
          {{this.CreateIcon}}
        </div>
      </button>

      {{#if this.createMenu.open}}
        <div
          class="absolute right-0 mt-2 w-72 bg-white shadow-xl rounded-lg border border-gray-200 z-50 transition-opacity duration-200 ease-out opacity-100"
        >
          <div
            class="flex items-center gap-4 px-4 py-3 hover:bg-gray-100 cursor-pointer transition-colors duration-150"
            {{on "click" this.openCreateTicket}}
          >
            <div class="bg-neutral-200 p-2 rounded-full">
              {{this.TicketLargeIcon}}
            </div>

            <div>
              <p class="text-sm font-medium text-gray-800">Create Ticket</p>
              <p class="text-xs text-gray-500 mt-2">Report an issue</p>
            </div>
          </div>
        </div>
      {{/if}}
    </div>
  </template>
}
