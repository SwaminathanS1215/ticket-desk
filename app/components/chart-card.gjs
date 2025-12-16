import Component from '@glimmer/component';
import chart from '../modifiers/chart';

export default class ChartCardComponent extends Component {
  get totalTickets() {
    return this.args.data.data.reduce((sum, item) => sum + item.value, 0);
  }

  <template>
    <div class="bg-white rounded-lg shadow p-6">
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-base font-medium text-gray-900">{{@data.title}}</h3>
        {{!-- <button class="text-gray-400 hover:text-gray-600" type="button">
          <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z"/>
          </svg>
        </button> --}}
      </div>
      
      <div class="relative" style="height: 300px; min-width:300px">
        <canvas {{chart @data}}></canvas>
        <div class="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
          <div class="text-2xl font-bold text-gray-600">{{this.totalTickets}}</div>
          <div class="text-sm font-bold text-gray-600 mt-1">tickets</div>
        </div>
      </div>
    </div>
  </template>
}