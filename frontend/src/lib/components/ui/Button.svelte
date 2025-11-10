<script>
  import { cn } from "$lib/utils.js";

  /**
   * @typedef {'default' | 'destructive' | 'outline' | 'secondary' | 'ghost' | 'link'} ButtonVariant
   * @typedef {'default' | 'sm' | 'lg' | 'icon'} ButtonSize
   */

  /** @type {ButtonVariant} */
  export let variant = "default";
  /** @type {ButtonSize} */
  export let size = "default";
  /** @type {string} */
  export let className = "";
  /** @type {boolean} */
  export let disabled = false;

  const variants = {
    default: "btn btn-primary",
    destructive: "btn bg-red-600 text-white hover:bg-red-700",
    outline: "btn btn-outline",
    secondary: "btn btn-secondary",
    ghost: "btn btn-ghost",
    link: "text-blue-600 hover:underline",
  };

  const sizes = {
    default: "",
    sm: "btn-sm",
    lg: "btn-lg",
    icon: "w-10 h-10 p-2",
  };

  $: buttonClass = cn(variants[variant], sizes[size], className);
</script>

<button class={buttonClass} {disabled} on:click {...$$restProps}>
  <slot />
</button>
