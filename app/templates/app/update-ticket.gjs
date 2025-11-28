import CreateTicketForm from '../../components/create-ticket-form.gjs';
<template>
  <CreateTicketForm @formData={{@model}} @onSubmit={{@controller.updateTicket}} @isEdit={{true}} />
</template>
