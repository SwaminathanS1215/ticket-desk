// components/filter-sidebar.gjs
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import CheckboxGroup from 'ticket-desk/components/ui/checkbox-group.gjs';
import CustomSelect from 'ticket-desk/components/ui/SelectDropDown.gjs';
import TagInput from 'ticket-desk/components/ui/Input.gjs';
import { array } from '@ember/helper';

function getDaysDifference(dateStr) {
  const today = new Date();
  const givenDate = new Date(dateStr);
  return Math.floor((today - givenDate) / (1000 * 60 * 60 * 24));
}

function getPeriodLabel(days) {
  if (days <= 7) return { label: 'Last 7 days', value: '7' };
  if (days <= 30) return { label: 'Last Month', value: '30' };
  if (days <= 90) return { label: 'Last 3 months', value: '90' };
  if (days <= 180) return { label: 'Last 6 months', value: '180' };

  return 'Custom';
}

export default class FilterSidebarComponent extends Component {
  /* ------------------ REQUIRED STATES ONLY ------------------ */

  // Search
  @tracked searchQuery = '';

  // Created Period
  @tracked createdPeriod = '';
  @tracked statusSearch = '';
  @tracked sourceSearch = '';
  @tracked selectedPriority = [];
  // CustomSelect dropdowns
  @tracked agentSearch = '';
  @tracked departmentSearch = '';
  @tracked groupSearch = '';
  @tracked plannedStartDate = 'Select a time period';
  @tracked plannedEndDate = 'Select a time period';

  @tracked selectedCategory = 'Select';

  // Checkbox Group groups
  @tracked selectedDueBy = [];
  @tracked selectedFirstResponse = [];

  @tracked selectedUrgency = [];
  @tracked selectedImpact = [];
  @tracked selectedType = [];

  // Tags + Requester
  @tracked requesterSearch = '';
  @tracked tagsSearch = '';

  constructor() {
    super(...arguments);
    this.populateFilters();
    console.log('filterData', this.args.filterData);
  }

  /* ------------------ FILTER VISIBILITY HELPER ------------------ */

  get showCreated() {
    if (!this.searchQuery.trim()) return true;
    return 'created'.includes(this.searchQuery.toLowerCase());
  }

  get showStatus() {
    if (!this.searchQuery.trim()) return true;
    return 'status'.includes(this.searchQuery.toLowerCase());
  }

  get showPriority() {
    if (!this.searchQuery.trim()) return true;
    return 'priority'.includes(this.searchQuery.toLowerCase());
  }

  get showSource() {
    if (!this.searchQuery.trim()) return true;
    return 'source'.includes(this.searchQuery.toLowerCase());
  }

  /* ------------------ ACTIONS (ONLY REQUIRED ONES) ------------------ */

  get isApplyDisabled() {
    return (
      !this.createdPeriod &&
      !this.statusSearch &&
      !this.sourceSearch &&
      this.selectedPriority.length === 0
    );
  }
  @action updateSearch(e) {
    this.searchQuery = e.target.value;
  }

  @action updateCreatedPeriod(v) {
    this.createdPeriod = v;
    this.triggerApiCall();
  }

  @action updateAgentSearch(v) {
    this.agentSearch = v;
  }

  @action updateRequesterSearch(e) {
    this.requesterSearch = e.target.value;
  }

  @action updateDepartmentSearch(v) {
    this.departmentSearch = v;
  }

  @action updateGroupSearch(v) {
    this.groupSearch = v;
  }

  @action updatePlannedStartDate(v) {
    this.plannedStartDate = v;
    this.triggerApiCall();
  }

  @action updatePlannedEndDate(v) {
    this.plannedEndDate = v;
    this.triggerApiCall();
  }

  @action updateStatusSearch(v) {
    this.statusSearch = v;
  }

  @action updateCheckboxGroup(field, values) {
    this[field] = values;
    this.triggerApiCall();
  }

  @action updateSourceSearch(v) {
    this.sourceSearch = v;
  }

  @action updateTagsSearch(e) {
    this.tagsSearch = e.target.value;
  }

  @action updateCategory(v) {
    this.selectedCategory = v;
    this.triggerApiCall();
  }

  @action triggerApiCall() {}
  @action resetFilter() {
    console.log('filhgshjsterData', this.selectedPriority);

    this.createdPeriod = '';
    this.statusSearch = '';
    this.sourceSearch = '';
    this.selectedPriority = [];
    this.args.onReset();
  }

  @action handleSubmitFilterValues(e) {
    e.preventDefault();
    const newObj = {
      created_at: this.createdPeriod,
      status: this.statusSearch,
      priority: this.selectedPriority,
      source: this.sourceSearch,
    };
    this.args.onApplyFilter(newObj);
  }
  parseQuery(queryString) {
    const params = new URLSearchParams(queryString);
    const result = {};
    console.log('queryString', queryString);
    for (let [key, value] of params.entries()) {
      if (key.endsWith('[]')) {
        key = key.replace('[]', '');
        result[key] = result[key] || [];
        result[key].push(value);
      } else {
        result[key] = value;
      }
    }

    return result;
  }
  populateFilters() {
    const query = this.args.filterData;
    if (!query) return;

    const parsed = this.parseQuery(query);
    console.log('queryString', parsed);
    this.statusSearch = parsed['q[status_eq]'] || '';
    this.sourceSearch = parsed['q[source_eq]'] || '';
    this.selectedPriority = (parsed['q[priority_in]'] || []).map(
      (p) => p[0].toUpperCase() + p.slice(1).toLowerCase()
    );

    const createdAt = parsed['q[created_at_gteq]'];
    if (createdAt) {
      const diff = getDaysDifference(createdAt);

      console.log('queryString', diff);
      this.createdPeriod = getPeriodLabel(diff);
      console.log('createdAt', this.createdPeriod);
    }
  }

  <template>
    <div
      class="w-full h-screen bg-gray-1003 border-l border-gray-200 flex flex-col"
      style="height: calc(100vh - 72px);"
    >

      {{! FIXED HEADER }}
      <div class="shrink-0 sticky top-0 z-10 border-b border-gray-200 px-4 py-3">
        <h2 class="text-base font-normal text-gray-900 mb-3">Filter</h2>

        <div class="relative">
          <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">🔍</span>

          <input
            type="text"
            placeholder="Search fields"
            value={{this.searchQuery}}
            {{on "input" this.updateSearch}}
            class="w-full pl-9 pr-3 py-2 text-sm border border-gray-300 rounded bg-white"
          />
        </div>
      </div>

      {{! SCROLLABLE MIDDLE CONTENT }}
      <div class="flex-1 overflow-y-auto px-4 py-4 space-y-5">

        {{! Created }}
        {{#if this.showCreated}}
          <CustomSelect
            @value={{this.createdPeriod}}
            @options={{@createdOptions}}
            @onChange={{this.updateCreatedPeriod}}
            @label="Created"
          />
        {{/if}}

        {{! Agents }}
        {{!-- <CustomSelect
          @value={{this.agentSearch}}
          @options={{array "Select"}}
          @onChange={{this.updateAgentSearch}}
          @label="Agents"
        /> --}}

        {{! Requesters }}
        {{!-- <TagInput
          @label="Requesters"
          @value={{this.requesterSearch}}
          @onChange={{this.updateRequesterSearch}}
        /> --}}

        {{!-- {{! Departments }}
        <CustomSelect
          @value={{this.departmentSearch}}
          @options={{array "Select"}}
          @onChange={{this.updateDepartmentSearch}}
          @label="Departments"
        /> --}}

        {{!-- {{! Groups }}
        <CustomSelect
          @value={{this.groupSearch}}
          @options={{array "Select"}}
          @onChange={{this.updateGroupSearch}}
          @label="Groups"
        /> --}}

        {{!-- {{! Planned Start Date }}
        <CustomSelect
          @value={{this.plannedStartDate}}
          @options={{array "Select a time period"}}
          @onChange={{this.updatePlannedStartDate}}
          @label="Planned Start Date"
        /> --}}

        {{!-- {{! Planned End Date }}
        <CustomSelect
          @value={{this.plannedEndDate}}
          @options={{array "Select a time period"}}
          @onChange={{this.updatePlannedEndDate}}
          @label="Planned End Date"
        /> --}}

        {{! Due By }}
        {{!-- <CheckboxGroup
          @options={{array "Overdue" "Tomorrow" "Next 8 Hours"}}
          @selected={{this.selectedDueBy}}
          @onChange={{fn this.updateCheckboxGroup "selectedDueBy"}}
          @label="Due By"
        /> --}}

        {{! First Response }}
        {{!-- <CheckboxGroup
          @options={{array "Overdue" "Due Today"}}
          @selected={{this.selectedFirstResponse}}
          @onChange={{fn this.updateCheckboxGroup "selectedFirstResponse"}}
          @label="Response"
        /> --}}

        {{! Status }}
        {{#if this.showStatus}}
          <CustomSelect
            @value={{this.statusSearch}}
            @options={{@statusOptions}}
            @onChange={{this.updateStatusSearch}}
            @label="Status"
          />
        {{/if}}

        {{! Priority }}
        {{#if this.showPriority}}
          <CheckboxGroup
            @options={{@priorityOptions}}
            @selected={{this.selectedPriority}}
            @onChange={{fn this.updateCheckboxGroup "selectedPriority"}}
            @label="Priority"
          />
        {{/if}}

        {{!-- {{! Urgency }}
        <CheckboxGroup
          @options={{@urgencyOptions}}
          @selected={{this.selectedUrgency}}
          @onChange={{fn this.updateCheckboxGroup "selectedUrgency"}}
          @label="Urgency"
        /> --}}
        {{!-- 
        {{! Impact }}
        <CheckboxGroup
          @options={{@impactOptions}}
          @selected={{this.selectedImpact}}
          @onChange={{fn this.updateCheckboxGroup "selectedImpact"}}
          @label="Impact"
        /> --}}

        {{! Type }}
        {{!-- <CheckboxGroup
          @options={{@typeOptions}}
          @selected={{this.selectedType}}
          @onChange={{fn this.updateCheckboxGroup "selectedType"}}
          @label="Type"
        /> --}}

        {{! Source }}
        {{#if this.showSource}}
          <CustomSelect
            @value={{this.sourceSearch}}
            @options={{@sourceOptions}}
            @onChange={{this.updateSourceSearch}}
            @label="Source"
          />
        {{/if}}

        {{! Tags }}
        {{!-- <TagInput @label="Tags" @value={{this.tagsSearch}} @onChange={{this.updateTagsSearch}} /> --}}

        {{! Category }}
        {{!-- <CustomSelect
          @value={{this.selectedCategory}}
          @options={{array "Select"}}
          @onChange={{this.updateCategory}}
          @label="Category"
        /> --}}

      </div>

      {{! FIXED FOOTER }}
      <div class="shrink-0 flex gap-1 bg-gray-1003 border-t border-gray-200 px-4 py-3">
        <button
          type="button"
          class="cursor-pointer w-full flex-1 px-1.5 py-1.5 text-xs text-white bg-gray-800 rounded-sm shadow-md hover:bg-gray-700 transition disabled:opacity-50"
          disabled={{this.isApplyDisabled}}
          {{on "click" this.handleSubmitFilterValues}}
        >
          Apply filters
        </button>
        <button
          type="button"
          class="w-[70px] cursor-pointer px-1.5 py-1.5 text-xs text-gray-800 bg-white border-1 border-gray-800 rounded-sm shadow-md hover:bg-gray-800 hover:text-white transition"
          {{on "click" this.resetFilter}}
        >
          Reset
        </button>
      </div>

    </div>
  </template>
}
