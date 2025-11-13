<script>
  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  const users = [
    {
      id: "1",
      name: "개발자123",
      email: "dev123@example.com",
      reputation: 1250,
      questionsCount: 45,
      answersCount: 128,
      joinDate: "2024. 3. 15.",
    },
    {
      id: "2",
      name: "프론트엔드러",
      email: "frontend@example.com",
      reputation: 2340,
      questionsCount: 67,
      answersCount: 203,
      joinDate: "2023. 11. 8.",
    },
    {
      id: "3",
      name: "타입마스터",
      email: "typemaster@example.com",
      reputation: 1890,
      questionsCount: 32,
      answersCount: 165,
      joinDate: "2024. 1. 22.",
    },
    {
      id: "4",
      name: "백엔드개발",
      email: "backend@example.com",
      reputation: 1540,
      questionsCount: 28,
      answersCount: 142,
      joinDate: "2024. 2. 10.",
    },
    {
      id: "5",
      name: "풀스택닌자",
      email: "fullstack@example.com",
      reputation: 3100,
      questionsCount: 89,
      answersCount: 267,
      joinDate: "2023. 8. 5.",
    },
    {
      id: "6",
      name: "리액트러버",
      email: "reactlover@example.com",
      reputation: 980,
      questionsCount: 21,
      answersCount: 87,
      joinDate: "2024. 5. 3.",
    },
  ];

  let searchQuery = "";
  let sortBy = "reputation";

  $: filteredUsers = users
    .filter((user) =>
      user.name.toLowerCase().includes(searchQuery.toLowerCase())
    )
    .sort((a, b) => {
      if (sortBy === "reputation") return b.reputation - a.reputation;
      if (sortBy === "questions") return b.questionsCount - a.questionsCount;
      if (sortBy === "answers") return b.answersCount - a.answersCount;
      return 0;
    });
</script>

<main class="flex-1 p-6 overflow-y-auto">
  <div class="max-w-5xl mx-auto">
    <div class="mb-8">
      <h1 class="text-4xl font-bold mb-4">사용자</h1>
      <p class="text-lg text-muted-foreground mb-6">
        우리 커뮤니티의 멤버들을 만나보세요.
      </p>

      <div class="flex flex-col md:flex-row gap-4 mb-6">
        <!-- Search Bar -->
        <input
          type="text"
          bind:value={searchQuery}
          placeholder="사용자 검색..."
          class="flex-1 px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary"
        />

        <!-- Sort Options -->
        <select
          bind:value={sortBy}
          class="px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary"
        >
          <option value="reputation">평판 순</option>
          <option value="questions">질문 수 순</option>
          <option value="answers">답변 수 순</option>
        </select>
      </div>
    </div>

    <!-- Users Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      {#each filteredUsers as user (user.id)}
        <div class="user-card p-6 bg-card rounded-lg border hover:border-primary transition-all">
          <div class="flex items-start justify-between mb-4">
            <div class="flex items-center gap-3">
              <div class="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center">
                <span class="text-xl font-bold text-primary">
                  {user.name[0]}
                </span>
              </div>
              <div>
                <h3 class="text-lg font-semibold">{user.name}</h3>
                <p class="text-sm text-muted-foreground">{user.email}</p>
              </div>
            </div>
            <div class="text-right">
              <div class="text-2xl font-bold text-primary">{user.reputation}</div>
              <div class="text-xs text-muted-foreground">평판</div>
            </div>
          </div>

          <div class="grid grid-cols-3 gap-4 pt-4 border-t">
            <div class="text-center">
              <div class="text-lg font-semibold">{user.questionsCount}</div>
              <div class="text-xs text-muted-foreground">질문</div>
            </div>
            <div class="text-center">
              <div class="text-lg font-semibold">{user.answersCount}</div>
              <div class="text-xs text-muted-foreground">답변</div>
            </div>
            <div class="text-center">
              <div class="text-xs text-muted-foreground mt-2">
                가입일<br />{user.joinDate}
              </div>
            </div>
          </div>
        </div>
      {/each}
    </div>

    {#if filteredUsers.length === 0}
      <div class="text-center py-12">
        <p class="text-muted-foreground">검색 결과가 없습니다.</p>
      </div>
    {/if}
  </div>
</main>

<style>
  .user-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
</style>
