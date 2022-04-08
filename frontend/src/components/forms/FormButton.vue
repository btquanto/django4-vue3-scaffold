<template>
  <button
    :class="{
      'focus:$ring-4 focus:$outline-none focus:$ring-cyan-300 $font-medium $rounded-lg $text-sm $w-full sm:$w-auto $px-5 $py-2.5 $text-center': true,
      '$text-white $bg-cyan-600 hover:$bg-cyan-700': type == 'confirm',
      '$text-cyan $bg-gray-100 hover:$bg-gray-200': type != 'confirm',
    }">
    {{ label }}
  </button>
</template>

<script setup></script>
<script>
export default {
  name: "FormButton",
  props: {
    label: { type: String, required: true },
    type: { type: String, default: "confirm" },
  },
};
</script>
