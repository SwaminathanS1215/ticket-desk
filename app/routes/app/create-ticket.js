import Route from '@ember/routing/route';
import { STATUS_OPTIONS, PRIORITY_OPTIONS, SOURCE_OPTIONS } from '../../constants';

export default class AppCreateTicketRoute extends Route {
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
}
