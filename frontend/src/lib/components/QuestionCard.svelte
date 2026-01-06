<script>
  import Badge from "$lib/components/ui/Badge.svelte";
  import { createEventDispatcher } from "svelte";

  // 질문 데이터 타입
  /**
   * @typedef {Object} Question
   * @property {string} id
   * @property {string} title
   * @property {string} content
   * @property {string} author
   * @property {string} createdAt
   * @property {number} views
   * @property {number} answers
   * @property {number} votes
   * @property {string[]} tags
   * @property {boolean} hasAcceptedAnswer
   */

  /** @type {Question} */
  export let question;

  const dispatch = createEventDispatcher();

  // 질문 클릭하면 상세페이지로
  function on_click() {
    dispatch("navigate", { page: "question", id: question.id });
  }

  // 시간 포맷 변환 (몇시간 전, 며칠 전 이런식으로)
  function get_time_text(date_str) {
    const date = new Date(date_str);
    const now = new Date();
    const diff_hours = Math.floor(
      (now.getTime() - date.getTime()) / (1000 * 60 * 60),
    );

    if (diff_hours < 1) return "방금 전";
    if (diff_hours < 24) return `${diff_hours}시간 전`;
    if (diff_hours < 168) return `${Math.floor(diff_hours / 24)}일 전`;
    return date.toLocaleDateString("ko-KR");
  }
</script>

<div
  class="p-4 hover:shadow-md transition-shadow cursor-pointer bg-card border rounded-lg"
  on:click={on_click}
  on:keydown={(e) => e.key === 'Enter' && on_click()}
  role="button"
  tabindex="0"
>
  <div class="flex items-start space-x-4">
    <!-- Stats Column -->
    <div
      class="flex flex-col items-center space-y-2 text-sm text-muted-foreground min-w-[60px]"
    >
      <div class="text-center">
        <div class="font-medium text-foreground">{question.votes}</div>
        <div>투표</div>
      </div>
      <div class="text-center">
        <div
          class={`font-medium ${question.hasAcceptedAnswer ? "text-green-600" : "text-foreground"}`}
        >
          {question.answers}
        </div>
        <div>답변</div>
      </div>
      <div class="text-center">
        <div class="font-medium text-foreground">{question.views}</div>
        <div>조회</div>
      </div>
    </div>

    <!-- Content Column -->
    <div class="flex-1 min-w-0">
      <h3 class="text-lg font-medium text-foreground mb-2 line-clamp-2">
        {question.title}
      </h3>
      <p class="text-muted-foreground text-sm mb-3 line-clamp-2">
        {question.content}
      </p>

      <!-- Tags -->
      <div class="flex flex-wrap gap-1 mb-3">
        {#each question.tags as tag (tag)}
          <button
            on:click={(e) => {
              e.stopPropagation();
              dispatch("navigate", { page: "questions", tag });
            }}
          >
            <Badge
              variant="secondary"
              className="text-xs bg-blue-100 text-blue-800 hover:bg-blue-200 cursor-pointer"
            >
              {tag}
            </Badge>
          </button>
        {/each}
      </div>

      <!-- Author and Time -->
      <div
        class="flex items-center justify-between text-xs text-muted-foreground"
      >
        <div class="flex items-center space-x-2">
          <div
            class="w-6 h-6 bg-primary/10 rounded-full flex items-center justify-center"
          >
            <span class="text-xs font-medium text-primary">
              {question.author.charAt(0).toUpperCase()}
            </span>
          </div>
          <span>{question.author}</span>
        </div>
        <span>{get_time_text(question.createdAt)}</span>
      </div>
    </div>
  </div>
</div>

<style>
  .line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }
</style>
