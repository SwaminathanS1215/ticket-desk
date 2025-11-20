<template>
  <div
    class="rounded-lg p-4 shadow-sm hover:shadow-md transition-all duration-200 border w-[175px] h-[110px] flex flex-col
      {{if
        @data.isAlert
        'bg-red-50 border-red-200'
        'bg-white border-gray-200'
      }}"
  >
    <div class="flex items-start justify-between mb-auto">
      <h3 class="text-gray-700 text-sm font-medium leading-tight flex-1 min-w-0 pr-2">
        {{@data.title}}
      </h3>
      
      {{#if @data.isAlert}}
        <div class="flex-shrink-0">
          <svg
            class="w-5 h-5 text-red-500"
            fill="currentColor"
            viewBox="0 0 20 20"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              fill-rule="evenodd"
              d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
              clip-rule="evenodd" 
            />
          </svg>
        </div>
      {{/if}}
    </div>
    
    <div class="mt-auto pb-1">
      <p class="{{if @data.isAlert 'text-[2.25rem] font-bold text-red-600' 'text-[2.25rem] font-bold text-blue-600'}} leading-none">
        {{@data.count}}
      </p>
    </div>
  </div>
</template>

