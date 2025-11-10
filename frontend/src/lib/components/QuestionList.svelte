<script>
  import QuestionCard from "$lib/components/QuestionCard.svelte";
  import Button from "$lib/components/ui/Button.svelte";
  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  /**
   * 네비게이션 이벤트 전달
   * @param {CustomEvent} event - 네비게이션 이벤트
   */
  function handleNavigate(event) {
    dispatch("navigate", event.detail);
  }

  // 샘플 데이터
  const questions = [
    {
      id: "1",
      title: "React에서 useState를 사용할 때 비동기 문제를 어떻게 해결하나요?",
      content:
        "setState를 호출한 후 바로 state 값을 참조하면 이전 값이 나오는 문제가 있습니다. 이를 해결하는 방법이 궁금합니다.",
      author: "개발자123",
      createdAt: "2024-01-15T10:30:00Z",
      views: 142,
      answers: 3,
      votes: 5,
      tags: ["react", "javascript", "useState"],
      hasAcceptedAnswer: true,
    },
    {
      id: "2",
      title: "SvelteKit에서 서버 사이드 렌더링 최적화 방법",
      content:
        "페이지 로딩 속도를 개선하기 위해 SSR을 최적화하고 싶습니다. 어떤 방법들이 있을까요?",
      author: "프론트엔드러",
      createdAt: "2024-01-15T09:15:00Z",
      views: 89,
      answers: 1,
      votes: 8,
      tags: ["svelte", "sveltekit", "ssr", "performance"],
      hasAcceptedAnswer: false,
    },
    {
      id: "3",
      title: "TypeScript에서 Generic 타입을 효과적으로 사용하는 방법",
      content:
        "복잡한 데이터 구조를 다룰 때 Generic을 어떻게 활용하면 좋을지 조언 부탁드립니다.",
      author: "타입스크립터",
      createdAt: "2024-01-15T08:45:00Z",
      views: 203,
      answers: 7,
      votes: 12,
      tags: ["typescript", "generics", "type-safety"],
      hasAcceptedAnswer: true,
    },
    {
      id: "4",
      title: "CSS Grid vs Flexbox: 언제 어떤 것을 사용해야 할까요?",
      content:
        "레이아웃을 구성할 때 Grid와 Flexbox 중 어떤 것을 선택해야 하는지 기준이 궁금합니다.",
      author: "CSS마스터",
      createdAt: "2024-01-15T07:20:00Z",
      views: 156,
      answers: 4,
      votes: 9,
      tags: ["css", "grid", "flexbox", "layout"],
      hasAcceptedAnswer: false,
    },
    {
      id: "5",
      title: "Node.js에서 메모리 누수를 방지하는 방법",
      content:
        "대용량 데이터를 처리하는 Node.js 애플리케이션에서 메모리 누수가 발생하는 문제를 해결하고 싶습니다.",
      author: "백엔드개발자",
      createdAt: "2024-01-15T06:10:00Z",
      views: 78,
      answers: 2,
      votes: 6,
      tags: ["nodejs", "memory-management", "performance"],
      hasAcceptedAnswer: false,
    },
  ];

  let sortBy = "newest";
  const sortOptions = [
    { value: "newest", label: "최신순" },
    { value: "votes", label: "투표순" },
    { value: "answers", label: "답변순" },
    { value: "views", label: "조회순" },
  ];

  $: sortedQuestions = [...questions].sort((a, b) => {
    switch (sortBy) {
      case "votes":
        return b.votes - a.votes;
      case "answers":
        return b.answers - a.answers;
      case "views":
        return b.views - a.views;
      case "newest":
      default:
        return (
          new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
        );
    }
  });
</script>

<main class="flex-1 p-6">
  <div class="max-w-4xl mx-auto">
    <!-- Header -->
    <div class="flex items-center justify-between mb-6">
      <div>
        <h1 class="text-2xl font-bold text-foreground mb-2">질문</h1>
        <p class="text-muted-foreground">
          개발자들의 질문과 답변을 나누는 공간입니다.
        </p>
      </div>
      <Button
        variant="default"
        on:click={() => dispatch("navigate", { page: "ask" })}
      >
        질문하기
      </Button>
    </div>

    <!-- Filters and Sort -->
    <div class="flex items-center justify-between mb-6 pb-4 border-b">
      <div class="flex items-center space-x-4">
        <span class="text-sm text-muted-foreground">
          총 {questions.length}개의 질문
        </span>
      </div>

      <div class="flex items-center space-x-2">
        <span class="text-sm text-muted-foreground">정렬:</span>
        <select
          bind:value={sortBy}
          class="text-sm border border-input rounded-md px-3 py-1 bg-background"
        >
          {#each sortOptions as option (option.value)}
            <option value={option.value}>{option.label}</option>
          {/each}
        </select>
      </div>
    </div>

    <!-- Question List -->
    <div class="space-y-4">
      {#each sortedQuestions as question (question.id)}
        <QuestionCard {question} on:navigate={handleNavigate} />
      {/each}
    </div>

    <!-- Pagination -->
    <div class="flex items-center justify-center mt-8 space-x-2">
      <Button variant="outline" size="sm" disabled>이전</Button>
      <Button variant="default" size="sm">1</Button>
      <Button variant="outline" size="sm">2</Button>
      <Button variant="outline" size="sm">3</Button>
      <Button variant="outline" size="sm">다음</Button>
    </div>
  </div>
</main>
