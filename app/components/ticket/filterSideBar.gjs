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

export default class FilterSidebarComponent extends Component {
  /* ------------------ REQUIRED STATES ONLY ------------------ */

  // Search
  @tracked searchQuery = '';

  // Created Period
  @tracked createdPeriod = 'Last 6 months';

  // CustomSelect dropdowns
  @tracked agentSearch = '';
  @tracked departmentSearch = '';
  @tracked groupSearch = '';
  @tracked plannedStartDate = 'Select a time period';
  @tracked plannedEndDate = 'Select a time period';
  @tracked statusSearch = '';
  @tracked sourceSearch = '';
  @tracked selectedCategory = 'Select';

  // Checkbox Group groups
  @tracked selectedDueBy = [];
  @tracked selectedFirstResponse = [];
  @tracked selectedPriority = [];
  @tracked selectedUrgency = [];
  @tracked selectedImpact = [];
  @tracked selectedType = [];

  // Tags + Requester
  @tracked requesterSearch = '';
  @tracked tagsSearch = '';

  /* ------------------ ACTIONS (ONLY REQUIRED ONES) ------------------ */

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
        <CustomSelect
          @value={{this.createdPeriod}}
          @options={{@createdOptions}}
          @onChange={{this.updateCreatedPeriod}}
          @label="Created"
        />

        {{! Agents }}
        <CustomSelect
          @value={{this.agentSearch}}
          @options={{array "Select"}}
          @onChange={{this.updateAgentSearch}}
          @label="Agents"
        />

        {{! Requesters }}
        <TagInput
          @label="Requesters"
          @value={{this.requesterSearch}}
          @onChange={{this.updateRequesterSearch}}
        />

        {{! Departments }}
        <CustomSelect
          @value={{this.departmentSearch}}
          @options={{array "Select"}}
          @onChange={{this.updateDepartmentSearch}}
          @label="Departments"
        />

        {{! Groups }}
        <CustomSelect
          @value={{this.groupSearch}}
          @options={{array "Select"}}
          @onChange={{this.updateGroupSearch}}
          @label="Groups"
        />

        {{! Planned Start Date }}
        <CustomSelect
          @value={{this.plannedStartDate}}
          @options={{array "Select a time period"}}
          @onChange={{this.updatePlannedStartDate}}
          @label="Planned Start Date"
        />

        {{! Planned End Date }}
        <CustomSelect
          @value={{this.plannedEndDate}}
          @options={{array "Select a time period"}}
          @onChange={{this.updatePlannedEndDate}}
          @label="Planned End Date"
        />

        {{! Due By }}
        <CheckboxGroup
          @options={{array "Overdue" "Tomorrow" "Next 8 Hours"}}
          @selected={{this.selectedDueBy}}
          @onChange={{fn this.updateCheckboxGroup "selectedDueBy"}}
          @label="Due By"
        />

        {{! First Response }}
        <CheckboxGroup
          @options={{array "Overdue" "Due Today"}}
          @selected={{this.selectedFirstResponse}}
          @onChange={{fn this.updateCheckboxGroup "selectedFirstResponse"}}
          @label="Response"
        />

        {{! Status }}
        <CustomSelect
          @value={{this.statusSearch}}
          @options={{array "Select"}}
          @onChange={{this.updateStatusSearch}}
          @label="Status"
        />

        {{! Priority }}
        <CheckboxGroup
          @options={{@priorityOptions}}
          @selected={{this.selectedPriority}}
          @onChange={{fn this.updateCheckboxGroup "selectedPriority"}}
          @label="Priority"
        />

        {{! Urgency }}
        <CheckboxGroup
          @options={{@urgencyOptions}}
          @selected={{this.selectedUrgency}}
          @onChange={{fn this.updateCheckboxGroup "selectedUrgency"}}
          @label="Urgency"
        />

        {{! Impact }}
        <CheckboxGroup
          @options={{@impactOptions}}
          @selected={{this.selectedImpact}}
          @onChange={{fn this.updateCheckboxGroup "selectedImpact"}}
          @label="Impact"
        />

        {{! Type }}
        <CheckboxGroup
          @options={{@typeOptions}}
          @selected={{this.selectedType}}
          @onChange={{fn this.updateCheckboxGroup "selectedType"}}
          @label="Type"
        />

        {{! Source }}
        <CustomSelect
          @value={{this.sourceSearch}}
          @options={{array "Select"}}
          @onChange={{this.updateSourceSearch}}
          @label="Source"
        />

        {{! Tags }}
        {{!-- <TagInput @label="Tags" @value={{this.tagsSearch}} @onChange={{this.updateTagsSearch}} /> --}}

        {{! Category }}
        <CustomSelect
          @value={{this.selectedCategory}}
          @options={{array "Select"}}
          @onChange={{this.updateCategory}}
          @label="Category"
        />

      </div>

      {{! FIXED FOOTER }}
      <div class="shrink-0 bg-gray-1003 border-t border-gray-200 px-4 py-3">
        <button
          type="button"
          class="w-full px-1.5 py-1.5 text-xs text-white bg-gray-800 rounded-sm shadow-md hover:bg-gray-700 transition"
        >
          Apply filters
        </button>
      </div>

    </div>
  </template>
}
