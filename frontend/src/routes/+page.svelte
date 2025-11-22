<script>
  import Header from "$lib/components/Header.svelte";
  import Sidebar from "$lib/components/Sidebar.svelte";
  import HomePage from "$lib/components/HomePage.svelte";
  import QuestionList from "$lib/components/QuestionList.svelte";
  import QuestionDetail from "$lib/components/QuestionDetail.svelte";
  import QuestionForm from "$lib/components/QuestionForm.svelte";
  import TagsPage from "$lib/components/TagsPage.svelte";
  import UsersPage from "$lib/components/UsersPage.svelte";
  import GuidelinesPage from "$lib/components/GuidelinesPage.svelte";
  import HelpPage from "$lib/components/HelpPage.svelte";
  import LoginPage from "$lib/components/LoginPage.svelte";
  import RegisterPage from "$lib/components/RegisterPage.svelte";

  // 전역 상태 관리
  let currentPage = "home";
  let showQuestionForm = false;
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
    
    // 질문하기 페이지는 모달로 처리
    if (page === "ask") {
      showQuestionForm = true;
      return;
    }
    
    currentPage = page;
    selectedQuestionId = id || null;
    sidebarOpen = false; // 모바일에서 사이드바 닫기
  }

  /**
   * 질문 작성 완료 처리
   */
  function handleQuestionSubmit(event) {
    console.log("질문 작성 완료:", event.detail);
    showQuestionForm = false;
    // 질문 목록 페이지로 이동
    currentPage = "questions";
  }

  /**
   * 질문 작성 취소
   */
  function handleQuestionCancel() {
    showQuestionForm = false;
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

      {#if currentPage === "home"}
        <HomePage on:navigate={handleNavigate} />
      {:else if currentPage === "questions"}
        <QuestionList on:navigate={handleNavigate} />
      {:else if currentPage === "question"}
        <QuestionDetail
          questionId={selectedQuestionId || "1"}
          {currentUser}
          on:navigate={handleNavigate}
        />
      {:else if currentPage === "tags"}
        <TagsPage on:navigate={handleNavigate} />
      {:else if currentPage === "users"}
        <UsersPage on:navigate={handleNavigate} />
      {:else if currentPage === "guidelines"}
        <GuidelinesPage on:navigate={handleNavigate} />
      {:else if currentPage === "help"}
        <HelpPage on:navigate={handleNavigate} />
      {:else}
        <HomePage on:navigate={handleNavigate} />
      {/if}
    </div>
  </div>
{/if}

<!-- 질문 작성 모달 -->
{#if showQuestionForm}
  <QuestionForm 
    on:submit={handleQuestionSubmit} 
    on:cancel={handleQuestionCancel} 
  />
{/if}
