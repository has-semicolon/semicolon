<script>
  import { cn } from "$lib/utils.js";

  /** @type {string} */
  export let type = "text";
  /** @type {string} */
  export let placeholder = "";
  /** @type {string} */
  export let value = "";
  /** @type {string} */
  export let className = "";
  /** @type {boolean} */
  export let disabled = false;

  $: inputClass = cn("input", className);
</script>

<input
  class={inputClass}
  {type}
  {placeholder}
  bind:value
  {disabled}
  on:input
  on:change
  on:focus
  on:blur
  {...$$restProps}
/>
