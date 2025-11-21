import Route from '@ember/routing/route';
import { STATUS_OPTIONS, PRIORITY_OPTIONS, SOURCE_OPTIONS } from '../../constants';
import { action } from '@ember/object';
import { service } from '@ember/service';

export default class CreateTicketRoute extends Route {
  @service router;

  model() {
    return {
      requestor: '',
      title: '',
      description: '',
      statusOptions: STATUS_OPTIONS,
      priorityOptions: PRIORITY_OPTIONS,
      sourceOptions: SOURCE_OPTIONS,

      status: STATUS_OPTIONS[0],
      priority: PRIORITY_OPTIONS[0],
      source: SOURCE_OPTIONS[0],
    };
  }

  @action async createTicket(form) {
    let response = await fetch('/tickets', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(form),
    });

    if (!response.ok) {
      throw new Error('Failed to create ticket');
    }

    this.router.transitionTo('app.ticket');
  }
}
