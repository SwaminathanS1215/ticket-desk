import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { API_ENDPOINTS } from '../constants';
import { service } from '@ember/service';

export default class EnumsService extends Service {
  @service api;

  @tracked priorities = {
    status: {
      open: 'Open',
      in_progress: 'In Progress',
      resolved: 'Resolved',
      on_hold: 'On Hold',
      closed: 'Closed',
    },
    priority: [
      {
        label: 'Low',
        value: 'low',
      },
      {
        label: 'Medium',
        value: 'medium',
      },
      {
        label: 'High',
        value: 'high',
      },
    ],
    source: [
      {
        label: 'Email',
        value: 'email',
      },
      {
        label: 'Phone',
        value: 'phone',
      },
      {
        label: 'Web',
        value: 'web',
      },
      {
        label: 'Chat',
        value: 'chat',
      },
    ],
    status_transitions: {
      admin: {
        open: ['in_progress', 'on_hold', 'resolved'],
        in_progress: ['resolved', 'on_hold'],
        on_hold: ['in_progress', 'resolved'],
        resolved: ['open', 'closed'],
        closed: ['open'],
      },
      agent: {
        open: ['in_progress', 'on_hold', 'resolved'],
        in_progress: ['resolved', 'on_hold'],
        on_hold: ['in_progress', 'resolved'],
        resolved: ['closed'],
      },
    },
  };

  constructor() {
    super(...arguments);
    if (localStorage.getItem('enums')) {
      this.priorities = JSON.parse(localStorage.getItem('enums'));
    } else {
      this.load();
    }
  }

  async load() {
    const response = await this.api.getJson(API_ENDPOINTS.GET_ENUMS);
    this.priorities = response || {};
    this.properties = {
      status: {
        open: 'Open',
        in_progress: 'In Progress',
        resolved: 'Resolved',
        on_hold: 'On Hold',
        closed: 'Closed',
      },
      priority: [
        {
          label: 'Low',
          value: 'low',
        },
        {
          label: 'Medium',
          value: 'medium',
        },
        {
          label: 'High',
          value: 'high',
        },
      ],
      source: [
        {
          label: 'Email',
          value: 'email',
        },
        {
          label: 'Phone',
          value: 'phone',
        },
        {
          label: 'Web',
          value: 'web',
        },
        {
          label: 'Chat',
          value: 'chat',
        },
      ],
      status_transitions: {
        admin: {
          open: ['in_progress', 'on_hold', 'resolved'],
          in_progress: ['resolved', 'on_hold'],
          on_hold: ['in_progress', 'resolved'],
          resolved: ['open', 'closed'],
          closed: ['open'],
        },
        agent: {
          open: ['in_progress', 'on_hold', 'resolved'],
          in_progress: ['resolved', 'on_hold'],
          on_hold: ['in_progress', 'resolved'],
          resolved: ['closed'],
        },
      },
    };

    localStorage.setItem('enums', JSON.stringify(this.priorities));
  }
}
