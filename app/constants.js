export const STATUS_OPTIONS = [
  { label: 'Open', value: 'open' },
  { label: 'In Progress', value: 'InProgress' },
  { label: 'Resolved', value: 'resolved' },
  { label: 'On Hold', value: 'OnHold' },
];

export const PRIORITY_OPTIONS = [
  { label: 'Low', value: 'low' },
  { label: 'Medium', value: 'medium' },
  { label: 'High', value: 'high' },
];

export const SOURCE_OPTIONS = ['email', 'phone', 'web', 'chat'];

export const ENUMS = {
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

export const API_ENDPOINTS = {
  DASHBOARD_SUMMARY: '/api/version1/dashboard/summary',
  DASHBOARD_CHARTS: '/api/version1/dashboard/charts',
  GET_TICKETS: '/api/version1/tickets',
  GET_USERS: '/api/version1/users',
  CREATE_TICKET: '/api/version1/tickets',
  UPDATE_TICKET: (ticketId) => `/api/version1/tickets/${ticketId}`,
  GET_NOTIFICATIONS: '/api/version1/notifications',
  GET_ENUMS: '/api/version1/ticket_form_options',
  MARK_NOTIFICATIONS_READ: '/api/version1/notifications/mark_read',
  MARK_ALL_NOTIFICATIONS_READ: '/api/version1/notifications/mark_all_read',
};
