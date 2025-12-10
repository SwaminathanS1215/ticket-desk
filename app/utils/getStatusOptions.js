export const getStatusOptions = (role, currentStatus, statusOptions, statusLabelMap) => {
  const transitions = statusOptions[role] || {};
  const allowed = transitions[currentStatus] || [];

  const currentOption = {
    value: currentStatus,
    label: statusLabelMap[currentStatus] || currentStatus,
    disabled: true
  };

  const transitionOptions = allowed.map((value) => ({
    value,
    label: statusLabelMap[value] || value,
    disabled: false
  }));

  return [currentOption, ...transitionOptions];
};
