import { pageTitle } from 'ember-page-title';
import TicketSummaryComponent from 'ticket-desk/components/ticket/ticketDetails.gjs';
import CreateTicketForm from '../../components/create-ticket-form.gjs';

<template>
  <div class="flex gap-4 w-full">
    <TicketSummaryComponent
      @details={{@model.ticket}}
      @postComment={{@controller.postComment}}
      @deleteComment={{@controller.deleteComment}}
      @uploadFile={{@controller.uploadFile}}
      @onRemoveExistedFile={{@controller.removeAttachment}}
    />
    <div class="flex-1 border border-gray-200 rounded-lg bg-white shadow-sm fixed overflow-y-auto right-0 top-20 bottom-2 w-1/3 py-2">
      <CreateTicketForm
        @formData={{@model.ticket}}
        @onSubmit={{@controller.updateTicket}}
        @isEdit={{true}}
      />
    </div>
  </div>
</template>
