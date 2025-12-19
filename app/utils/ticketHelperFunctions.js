export function buildRansackQuery(filters) {
  if (!filters) return '';
  const params = [];

  // Helper to format date YYYY-MM-DD
  const formatDate = (date) => {
    return date.toISOString().split('T')[0];
  };

  // 1. Created At → last X days → actual date
  if (filters.created_at?.value) {
    const daysAgo = parseInt(filters.created_at.value, 10);

    const today = new Date(); // today = 09 Dec 2025
    const targetDate = new Date(today);
    targetDate.setDate(today.getDate() - daysAgo); // subtract X days

    const finalDate = formatDate(targetDate); // convert to YYYY-MM-DD

    params.push(`q[created_at_gteq]=${finalDate}`);
  }

  // 2. Status (single value)
  if (filters.status) {
    params.push(`q[status_eq]=${encodeURIComponent(filters.status)}`);
  }

  // 3. Priority (array → _in)
  if (Array.isArray(filters.priority) && filters.priority.length > 0) {
    filters.priority.forEach((p) => {
      params.push(`q[priority_in][]=${encodeURIComponent(p.toLowerCase())}`);
    });
  }

  // 4. Source (single value)
  if (filters.source) {
    params.push(`q[source_eq]=${encodeURIComponent(filters.source)}`);
  }

  return params.join('&');
}
