import Component from '@glimmer/component';
import CommentSectionComponent from './commentSection.gjs';
import { LinkTo } from '@ember/routing';
import formatDateTime from 'ticket-desk/utils/format-date-time';

export default class TicketSummaryComponent extends Component {
  <template>
    <div class="flex-col border-right border-gray-200 max-w-4xl w-full">
      <LinkTo
        @route="app.ticket"
        class="inline-flex items-center gap-2 px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white font-medium rounded-lg transition-colors duration-200 shadow-sm hover:shadow-md"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M10 19l-7-7m0 0l7-7m-7 7h18"
          />
        </svg>
        Back
      </LinkTo>
      <div class="flex items-start space-x-4 p-4 border-b border-gray-200 mt-12">
        {{! Icon box }}
        <div class="w-12 h-12 flex items-center justify-center bg-[#10b981] rounded-md">
          {{! Static icon }}
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="2"
            stroke="white"
            class="w-6 h-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 
               2 0 012-2h3l1 2h6l1-2h3a2 2 0 012 2v14a2 
               2 0 01-2 2z"
            />
          </svg>
        </div>

        {{! Content }}
        <div class="flex flex-col">
          <h2 class="text-lg font-semibold text-gray-900">
            {{@details.title}}
          </h2>

          <p class="text-sm text-gray-700">
            <span class="text-gray-500">
              Created on
              {{formatDateTime @details.created_at}}
              by
              {{@details.requestor}}
            </span>
          </p>
        </div>
      </div>
      <div class="mt-12">
        <h2 class="font-bold text-xl">Details</h2>

        <div class="mt-12 border border-blue-600 rounded-sm py-4 px-4 bg-sky-200">
          <h3 class="text-lg font-bold">Description</h3>
          <p class="mt-6">{{@details.description}}</p>
        </div>
      </div>
      <CommentSectionComponent
        @comments={{@details.comments}}
        @postComment={{@postComment}}
        @deleteComment={{@deleteComment}}
        @uploadFile={{@uploadFile}}
        @existedFile={{@details.attachment}}
        @onRemoveExistedFile={{@onRemoveExistedFile}}
      />
    </div>
  </template>
}
