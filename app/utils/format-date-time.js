import dayjs from 'dayjs';

export default function formatDateTime(dateString) {
  if (!dateString) return "";

  return dayjs(dateString).format("DD MMM YYYY, hh:mm A");
}
