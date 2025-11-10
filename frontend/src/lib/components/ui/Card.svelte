<script>
  import { cn } from "$lib/utils.js";

  /** @type {string} */
  export let className = "";

  $: cardClass = cn("card", className);
</script>

<div class={cardClass} {...$$restProps}>
  <slot />
</div>
