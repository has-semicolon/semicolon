<script>
  import Header from "$lib/components/Header.svelte";
  import Sidebar from "$lib/components/Sidebar.svelte";
  import QuestionList from "$lib/components/QuestionList.svelte";
  import QuestionDetail from "$lib/components/QuestionDetail.svelte";
  import LoginPage from "$lib/components/LoginPage.svelte";
  import RegisterPage from "$lib/components/RegisterPage.svelte";

  // 전역 상태 관리
  let currentPage = "home";
  /** @type {string | null} */
  let selectedQuestionId = null;
  /** @type {{ name: string; email?: string; reputation: number } | null} */
  let currentUser = null;
  let sidebarOpen = false;

  /**
   * 페이지 네비게이션 처리
   * @param {CustomEvent} event - 네비게이션 이벤트
   */
  function handleNavigate(event) {
    const { page, id } = event.detail;
    currentPage = page;
    selectedQuestionId = id || null;
    sidebarOpen = false; // 모바일에서 사이드바 닫기
  }

  /**
   * 로그인 처리
   * @param {CustomEvent} event - 로그인 이벤트
   */
  function handleLogin(event) {
    currentUser = event.detail;
  }

  /**
   * 로그아웃 처리
   */
  function handleLogout() {
    currentUser = null;
    currentPage = "home";
  }

  /**
   * 사이드바 토글
   */
  function toggleSidebar() {
    sidebarOpen = !sidebarOpen;
  }

  $: isAuthPage = currentPage === "login" || currentPage === "register";
</script>

<svelte:head>
  <title>Semicolon - 개발자 커뮤니티</title>
  <meta name="description" content="개발자들의 질문과 답변을 나누는 커뮤니티" />
</svelte:head>

{#if isAuthPage}
  {#if currentPage === "login"}
    <LoginPage on:navigate={handleNavigate} on:login={handleLogin} />
  {:else if currentPage === "register"}
    <RegisterPage on:navigate={handleNavigate} on:login={handleLogin} />
  {/if}
{:else}
  <div class="min-h-screen bg-background">
    <Header
      {currentUser}
      onToggleSidebar={toggleSidebar}
      on:navigate={handleNavigate}
    />

    <div class="flex min-h-screen">
      <div
        class={`${sidebarOpen ? "block" : "hidden"} md:block fixed md:relative z-40 md:z-auto`}
      >
        <!-- Mobile overlay -->
        {#if sidebarOpen}
          <div
            class="md:hidden fixed inset-0 bg-black/50"
            on:click={() => (sidebarOpen = false)}
            on:keydown={(e) => e.key === "Escape" && (sidebarOpen = false)}
            role="button"
            tabindex="0"
          ></div>
        {/if}
        <Sidebar {currentPage} on:navigate={handleNavigate} />
      </div>

      {#if currentPage === "question"}
        <QuestionDetail
          questionId={selectedQuestionId || "1"}
          {currentUser}
          on:navigate={handleNavigate}
        />
      {:else}
        <QuestionList on:navigate={handleNavigate} />
      {/if}
    </div>
  </div>
{/if}
