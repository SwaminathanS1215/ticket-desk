import CreateTicketForm from '../../components/create-ticket-form.gjs';
import Component from '@glimmer/component';

export default class AppTicketCreateTemplate extends Component {
  <template>
    <CreateTicketForm
      @formData={{@model}}
      @onSubmit={{this.route.createTicket}}
    />
  </template>
}
