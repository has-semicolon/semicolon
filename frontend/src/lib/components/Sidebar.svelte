<script>
  import { createEventDispatcher } from "svelte";
  import { cn } from "$lib/utils.js";

  /** @type {string} */
  export let currentPage = "home";

  const dispatch = createEventDispatcher();

  /**
   * 페이지 이동 이벤트 발생
   * @param {string} page - 이동할 페이지
   */
  function handleNavigate(page) {
    dispatch("navigate", { page });
  }

  const menuItems = [
    {
      id: "home",
      label: "홈",
      icon: "M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m0 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1h3a1 1 0 001-1V10M9 21h6",
    },
    {
      id: "questions",
      label: "질문",
      icon: "M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z",
    },
    {
      id: "tags",
      label: "태그",
      icon: "M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z",
    },
    {
      id: "users",
      label: "사용자",
      icon: "M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z",
    },
  ];

  const communityItems = [
    {
      id: "guidelines",
      label: "가이드라인",
      icon: "M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z",
    },
    {
      id: "help",
      label: "도움말",
      icon: "M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z",
    },
  ];
</script>

<aside class="w-64 bg-background border-r min-h-screen">
  <div class="p-4">
    <!-- Main Navigation -->
    <nav class="space-y-1">
      {#each menuItems as item (item.id)}
        <button
          class={cn(
            "w-full flex items-center px-3 py-2 text-sm font-medium rounded-md transition-colors",
            currentPage === item.id
              ? "bg-primary text-primary-foreground"
              : "text-muted-foreground hover:text-foreground hover:bg-accent",
          )}
          on:click={() => handleNavigate(item.id)}
        >
          <svg
            class="w-5 h-5 mr-3"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d={item.icon}
            />
          </svg>
          {item.label}
        </button>
      {/each}
    </nav>

    <!-- Divider -->
    <div class="my-6 border-t"></div>

    <!-- Community Section -->
    <div>
      <h3
        class="px-3 text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-3"
      >
        커뮤니티
      </h3>
      <nav class="space-y-1">
        {#each communityItems as item (item.id)}
          <button
            class={cn(
              "w-full flex items-center px-3 py-2 text-sm font-medium rounded-md transition-colors",
              currentPage === item.id
                ? "bg-primary text-primary-foreground"
                : "text-muted-foreground hover:text-foreground hover:bg-accent",
            )}
            on:click={() => handleNavigate(item.id)}
          >
            <svg
              class="w-5 h-5 mr-3"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d={item.icon}
              />
            </svg>
            {item.label}
          </button>
        {/each}
      </nav>
    </div>

    <!-- Stats Section -->
    <div class="mt-8 p-3 bg-muted rounded-lg">
      <h4 class="text-sm font-medium mb-2">활동 통계</h4>
      <div class="space-y-2 text-sm text-muted-foreground">
        <div class="flex justify-between">
          <span>질문</span>
          <span>1,234</span>
        </div>
        <div class="flex justify-between">
          <span>답변</span>
          <span>5,678</span>
        </div>
        <div class="flex justify-between">
          <span>사용자</span>
          <span>890</span>
        </div>
      </div>
    </div>
  </div>
</aside>
