import { pageTitle } from 'ember-page-title';
import TicketSummaryComponent from 'ticket-desk/components/ticket/ticketDetails.gjs';

<template>
  <TicketSummaryComponent
    @details={{@model}}
    @postComment={{@controller.postComment}}
    @deleteComment={{@controller.deleteComment}}
    @uploadFile={{@controller.uploadFile}}
    @onRemoveExistedFile={{@controller.removeAttachment}}
  />
</template>
