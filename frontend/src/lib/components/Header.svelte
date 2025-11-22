<script>
  import Button from "$lib/components/ui/Button.svelte";
  import Input from "$lib/components/ui/Input.svelte";
  import Badge from "$lib/components/ui/Badge.svelte";
  import { createEventDispatcher } from "svelte";

  /**
   * @typedef {Object} User
   * @property {string} name - 사용자 이름
   * @property {string} [avatar] - 아바타 URL
   * @property {number} reputation - 평판 점수
   */

  /** @type {User | null} */
  export let currentUser = null;
  /** @type {() => void} */
  export let onToggleSidebar = () => {};

  const dispatch = createEventDispatcher();

  /**
   * 페이지 이동 이벤트 발생
   * @param {string} page - 이동할 페이지
   */
  function handleNavigate(page) {
    dispatch("navigate", { page });
  }

  let searchValue = "";
</script>

<header class="border-b bg-background sticky top-0 z-50">
  <div class="container mx-auto px-4 py-3">
    <div class="flex items-center justify-between gap-4">
      <!-- Mobile Menu & Logo -->
      <div class="flex items-center space-x-2">
        <Button
          variant="ghost"
          size="sm"
          className="md:hidden"
          on:click={onToggleSidebar}
        >
          <!-- Menu Icon -->
          <svg
            class="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 6h16M4 12h16M4 18h16"
            />
          </svg>
        </Button>
        <div
          class="flex items-center space-x-3 cursor-pointer"
          on:click={() => handleNavigate("home")}
          on:keydown={(e) => e.key === "Enter" && handleNavigate("home")}
          role="button"
          tabindex="0"
        >
          <!-- Logo placeholder -->
          <div
            class="h-8 w-8 bg-primary rounded flex items-center justify-center text-primary-foreground font-bold"
          >
            ;
          </div>
          <span class="font-bold text-lg whitespace-nowrap">Semicolon</span>
        </div>
      </div>

      <!-- Search Bar -->
      <div class="max-w-md w-full hidden md:block">
        <div class="relative">
          <Input
            type="search"
            placeholder="질문 검색..."
            className="pr-10"
            bind:value={searchValue}
          />
          <div style="padding-right: 2.5rem;"></div>
          <!-- Search Icon -->
          <svg
            class="absolute right-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
            />
          </svg>
        </div>
      </div>

      <!-- Navigation & User Actions -->
      <div class="flex items-center space-x-2 sm:space-x-4">
        {#if currentUser}
          <Button
            variant="outline"
            size="sm"
            on:click={() => handleNavigate("ask")}
            className="hidden sm:flex items-center gap-2"
          >
            <!-- Plus Circle Icon -->
            <svg
              class="w-4 h-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 6v6m0 0v6m0-6h6m-6 0H6"
              />
            </svg>
            질문하기
          </Button>

          <Button
            variant="outline"
            size="sm"
            on:click={() => handleNavigate("ask")}
            className="sm:hidden p-2"
          >
            <!-- Plus Circle Icon -->
            <svg
              class="w-4 h-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 6v6m0 0v6m0-6h6m-6 0H6"
              />
            </svg>
          </Button>

          <Button variant="ghost" size="sm" className="relative p-2">
            <!-- Bell Icon -->
            <svg
              class="w-5 h-5"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 17h5l-5-5v5zM15 17v-5a6 6 0 00-12 0v5l-5 5h5m7-5a3 3 0 11-6 0 3 3 0 016 0z"
              />
            </svg>
            <Badge
              className="absolute -top-1 -right-1 px-1 min-w-[18px] h-[18px] text-xs flex items-center justify-center"
            >
              3
            </Badge>
          </Button>

          <div
            class="flex items-center space-x-2 cursor-pointer hover:bg-accent rounded-lg p-2"
            on:click={() => handleNavigate("profile")}
            on:keydown={(e) => e.key === "Enter" && handleNavigate("profile")}
            role="button"
            tabindex="0"
          >
            <div
              class="w-8 h-8 bg-primary/10 rounded-full flex items-center justify-center"
            >
              <!-- User Icon -->
              <svg
                class="w-4 h-4 text-primary"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                />
              </svg>
            </div>
            <div class="text-sm hidden sm:block">
              <div class="font-medium">{currentUser.name}</div>
              <div class="text-muted-foreground text-xs">
                {currentUser.reputation}
              </div>
            </div>
          </div>
        {:else}
          <Button
            variant="ghost"
            size="sm"
            on:click={() => handleNavigate("login")}
            className="hidden sm:inline-flex"
          >
            로그인
          </Button>
          <Button
            variant="default"
            size="sm"
            on:click={() => handleNavigate("register")}
          >
            <span class="hidden sm:inline">회원가입</span>
            <span class="sm:hidden">가입</span>
          </Button>
        {/if}
      </div>
    </div>
  </div>
</header>
