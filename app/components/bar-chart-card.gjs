import Component from '@glimmer/component';
import barChart from '../modifiers/bar-chart';

export default class BarChartCardComponent extends Component {
  <template>
    <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
      <div class="flex items-center justify-between mb-6">
        <h3 class="text-base font-semibold text-gray-800">{{@data.title}}</h3>
        <button class="text-gray-400 hover:text-gray-600 p-1" type="button">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path
              d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z"
            />
          </svg>
        </button>
      </div>

      <div class="space-y-5 pt-6">
        {{#each @data.data as |item|}}
          <div class="items-center justify-between">
            <div class="flex justify-between">
              <p class="text-gray-700 w-20">{{item.label}}</p>
              <p
                class="ml-3 text-gray-700"
              >{{item.value}}</p>
            </div>

            <div class="flex items-center w-full">
              <div class="relative w-full h-3 bg-gray-200 rounded-full overflow-hidden">

                <div
                  class="absolute h-3 rounded-full"
                  style="
                    width: min({{item.value}}0%, 100%);
                background: linear-gradient(to right, #ec4899, #a855f7, #8b5cf6);
              "
                >
                </div>
              </div>

            </div>
          </div>
        {{/each}}
      </div>
    </div>
  </template>
}
