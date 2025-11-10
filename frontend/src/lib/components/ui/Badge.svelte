<script>
  import { cn } from "$lib/utils.js";

  /**
   * @typedef {'default' | 'secondary' | 'destructive' | 'outline'} BadgeVariant
   */

  /** @type {BadgeVariant} */
  export let variant = "default";
  /** @type {string} */
  export let className = "";

  const variants = {
    default: "badge badge-primary",
    secondary: "badge badge-secondary",
    destructive: "badge bg-red-600 text-white",
    outline: "badge border-gray-300 bg-white text-gray-700",
  };

  $: badgeClass = cn(variants[variant], className);
</script>

<div class={badgeClass} {...$$restProps}>
  <slot />
</div>
