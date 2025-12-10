import CreateTicketForm from '../../components/create-ticket-form.gjs';

<template>
  <div class="max-w-4xl">
    <CreateTicketForm
      @formData={{@model}}
      @onSubmit={{@controller.createTicket}}
      @uploadFile={{@controller.uploadFile}}
    />
  </div>
</template>
