<template>
  <div class="$relative $z-0 $group">
    <textarea
      :value="modelValue"
      type="text"
      :name="name"
      class="$block $py-2.5 $px-0 $w-full $text-sm $text-gray-900 $bg-transparent $border-0 $border-b-2 $border-gray-300 $appearance-none focus:$outline-none focus:$ring-0 focus:$border-cyan-600 $peer"
      placeholder=" "
      required
      @input="$emit('update:modelValue', $event.target.value)"></textarea>
    <label
      :for="name"
      class="$absolute $text-sm $text-gray-500 $duration-300 $transform $-translate-y-6 $scale-75 $top-3 $-z-10 $origin-[0] peer-focus:$left-0 peer-focus:$text-cyan-600 peer-placeholder-shown:$scale-100 peer-placeholder-shown:$translate-y-0 peer-focus:$scale-75 peer-focus:$-translate-y-6"
      >{{ label }}</label
    >
  </div>
</template>

<script setup></script>
<script>
export default {
  name: "TextAreaField",
  props: {
    name: { type: String, required: true },
    label: { type: String, required: true },
    modelValue: { type: String, default: "" },
  },
};
</script>
