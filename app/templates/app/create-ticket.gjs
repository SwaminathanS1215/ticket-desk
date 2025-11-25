import CreateTicketForm from '../../components/create-ticket-form.gjs';
import Component from '@glimmer/component';

export default class AppCreateTicketTemplate extends Component {
  <template>
    <div>Controller Debug: {{this.debug}}</div>
    <CreateTicketForm
      @formData={{@model}}
      @onSubmit={{@controller.createTicket}}
    />
  </template>
}
