<script>
  import Card from "$lib/components/ui/Card.svelte";
  import Button from "$lib/components/ui/Button.svelte";
  import Badge from "$lib/components/ui/Badge.svelte";
  import { createEventDispatcher } from "svelte";

  /** @type {string} */
  export let questionId;

  /**
   * @typedef {Object} User
   * @property {number} id
   * @property {string} username
   * @property {string} [full_name]
   */

  /** @type {User | null} */
  export let currentUser = null;

  const dispatch = createEventDispatcher();

  /**
   * 네비게이션 이벤트 발생
   * @param {string} page - 이동할 페이지
   */
  function handleNavigate(page) {
    dispatch("navigate", { page });
  }

  // 샘플 질문 데이터
  const question = {
    id: questionId,
    title: "React에서 useState를 사용할 때 비동기 문제를 어떻게 해결하나요?",
    content: `setState를 호출한 후 바로 state 값을 참조하면 이전 값이 나오는 문제가 있습니다.

예를 들어:
\`\`\`javascript
const [count, setCount] = useState(0);

const handleClick = () => {
  setCount(count + 1);
  console.log(count); // 여전히 이전 값이 출력됨
};
\`\`\`

이런 상황에서 업데이트된 값을 즉시 사용하려면 어떻게 해야 할까요?`,
    author: "개발자123",
    authorReputation: 1250,
    createdAt: "2024-01-15T10:30:00Z",
    views: 142,
    votes: 5,
    tags: ["react", "javascript", "useState"],
    hasAcceptedAnswer: true,
  };

  const answers = [
    {
      id: "1",
      content: `useState의 setter는 비동기적으로 동작하기 때문에 setState 호출 직후에는 이전 값이 참조됩니다.

해결 방법은 여러 가지가 있습니다:

1. **useEffect 사용:**
\`\`\`javascript
useEffect(() => {
  console.log(count); // 업데이트된 값
}, [count]);
\`\`\`

2. **함수형 업데이트 사용:**
\`\`\`javascript
setCount(prevCount => {
  const newCount = prevCount + 1;
  console.log(newCount); // 새로운 값
  return newCount;
});
\`\`\`

3. **지역 변수 사용:**
\`\`\`javascript
const newCount = count + 1;
setCount(newCount);
console.log(newCount); // 새로운 값
\`\`\``,
      author: "React전문가",
      authorReputation: 3450,
      createdAt: "2024-01-15T11:15:00Z",
      votes: 8,
      isAccepted: true,
      comments: [
        {
          id: "c1",
          content: "useEffect를 사용하는 방법이 가장 일반적이네요. 감사합니다!",
          author: "초보개발자",
          createdAt: "2024-01-15T11:30:00Z",
        },
        {
          id: "c2",
          content: "함수형 업데이트 방법을 몰랐는데 유용할 것 같습니다.",
          author: "개발자123",
          createdAt: "2024-01-15T11:45:00Z",
        },
      ],
    },
    {
      id: "2",
      content: `추가로 useRef를 사용하는 방법도 있습니다:

\`\`\`javascript
const countRef = useRef(count);

const handleClick = () => {
  const newCount = count + 1;
  setCount(newCount);
  countRef.current = newCount;
  console.log(countRef.current); // 업데이트된 값
};
\`\`\`

이 방법은 즉시 업데이트된 값이 필요한 경우에 유용합니다.`,
      author: "프론트개발자",
      authorReputation: 890,
      createdAt: "2024-01-15T12:30:00Z",
      votes: 3,
      isAccepted: false,
      comments: [],
    },
  ];

  let newAnswerContent = "";
  let userVote = 0; // -1: downvote, 0: no vote, 1: upvote
  /** @type {Record<string, boolean>} */
  let showCommentForm = {}; // 답변별 댓글 폼 표시 여부
  /** @type {Record<string, string>} */
  let newCommentContent = {}; // 답변별 댓글 내용

  /**
   * 투표 처리
   * @param {number} value - 투표 값 (1 또는 -1)
   */
  function handleVote(value) {
    if (!currentUser) {
      alert("로그인이 필요합니다.");
      return;
    }
    userVote = userVote === value ? 0 : value;
  }

  /**
   * 답변 제출
   */
  function handleSubmitAnswer() {
    if (!currentUser) {
      alert("로그인이 필요합니다.");
      return;
    }
    if (!newAnswerContent.trim()) {
      alert("답변 내용을 입력해주세요.");
      return;
    }

    // 답변 제출 로직
    console.log("답변 제출:", newAnswerContent);
    newAnswerContent = "";
  }

  /**
   * 댓글 폼 토글
   * @param {string} answerId - 답변 ID
   */
  function toggleCommentForm(answerId) {
    if (!currentUser) {
      alert("로그인이 필요합니다.");
      return;
    }
    showCommentForm[answerId] = !showCommentForm[answerId];
  }

  /**
   * 댓글 제출
   * @param {string} answerId - 답변 ID
   */
  function handleSubmitComment(answerId) {
    if (!newCommentContent[answerId]?.trim()) {
      alert("댓글 내용을 입력해주세요.");
      return;
    }

    // 댓글 제출 로직
    console.log(`답변 ${answerId}에 댓글 제출:`, newCommentContent[answerId]);
    
    // 댓글 추가 (실제로는 API 호출 후 업데이트)
    const answer = answers.find(a => a.id === answerId);
    if (answer && currentUser) {
      const username = (currentUser).username || (currentUser).full_name || "사용자";
      answer.comments = [...answer.comments, {
        id: `c${Date.now()}`,
        content: newCommentContent[answerId],
        author: username,
        createdAt: new Date().toISOString(),
      }];
    }

    newCommentContent[answerId] = "";
    showCommentForm[answerId] = false;
  }

  /**
   * 시간을 상대적 형식으로 변환
   * @param {string} dateString - 날짜 문자열
   * @returns {string} 상대적 시간 표현
   */
  function formatRelativeTime(dateString) {
    const date = new Date(dateString);
    const now = new Date();
    const diffInHours = Math.floor(
      (now.getTime() - date.getTime()) / (1000 * 60 * 60),
    );

    if (diffInHours < 1) return "방금 전";
    if (diffInHours < 24) return `${diffInHours}시간 전`;
    if (diffInHours < 168) return `${Math.floor(diffInHours / 24)}일 전`;
    return date.toLocaleDateString("ko-KR");
  }
</script>

<main class="flex-1 p-6">
  <div class="max-w-4xl mx-auto">
    <!-- Breadcrumb -->
    <nav class="mb-6 text-sm text-muted-foreground">
      <button
        class="hover:text-foreground"
        on:click={() => handleNavigate("home")}
      >
        홈
      </button>
      <span class="mx-2">/</span>
      <button
        class="hover:text-foreground"
        on:click={() => handleNavigate("questions")}
      >
        질문
      </button>
      <span class="mx-2">/</span>
      <span class="text-foreground">질문 상세</span>
    </nav>

    <!-- Question -->
    <Card className="p-6 mb-6">
      <div class="flex items-start space-x-4">
        <!-- Vote Section -->
        <div class="flex flex-col items-center space-y-2">
          <button
            class={`p-1 rounded hover:bg-accent ${userVote === 1 ? "text-orange-500" : "text-muted-foreground"}`}
            on:click={() => handleVote(1)}
            aria-label="추천"
          >
            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
              <path d="M7.41 15.41L12 10.83l4.59 4.58L18 14l-6-6-6 6z" />
            </svg>
          </button>
          <span class="text-lg font-medium">{question.votes + userVote}</span>
          <button
            class={`p-1 rounded hover:bg-accent ${userVote === -1 ? "text-orange-500" : "text-muted-foreground"}`}
            on:click={() => handleVote(-1)}
            aria-label="비추천"
          >
            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
              <path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6z" />
            </svg>
          </button>
        </div>

        <!-- Content -->
        <div class="flex-1">
          <h1 class="text-2xl font-bold text-foreground mb-4">
            {question.title}
          </h1>

          <div class="prose max-w-none mb-4">
            {#each question.content.split("\n") as paragraph}
              {#if paragraph.startsWith("```")}
                <pre class="bg-muted p-3 rounded text-sm overflow-x-auto"><code
                    >{paragraph
                      .replace(/```\w*\n?/, "")
                      .replace(/```$/, "")}</code
                  ></pre>
              {:else if paragraph.trim()}
                <p class="mb-3">{paragraph}</p>
              {/if}
            {/each}
          </div>

          <!-- Tags -->
          <div class="flex flex-wrap gap-2 mb-4">
            {#each question.tags as tag (tag)}
              <Badge variant="secondary" className="bg-blue-100 text-blue-800">
                {tag}
              </Badge>
            {/each}
          </div>

          <!-- Author and Meta -->
          <div
            class="flex items-center justify-between text-sm text-muted-foreground"
          >
            <div class="flex items-center space-x-4">
              <span>조회 {question.views}</span>
              <span>{formatRelativeTime(question.createdAt)}에 질문됨</span>
            </div>
            <div class="flex items-center space-x-2">
              <div
                class="w-8 h-8 bg-primary/10 rounded-full flex items-center justify-center"
              >
                <span class="text-sm font-medium text-primary">
                  {question.author.charAt(0).toUpperCase()}
                </span>
              </div>
              <div>
                <div class="font-medium text-foreground">{question.author}</div>
                <div class="text-xs">평판 {question.authorReputation}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Card>

    <!-- Answers Header -->
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-xl font-semibold">
        {answers.length}개의 답변
      </h2>
    </div>

    <!-- Answers -->
    <div class="space-y-6 mb-8">
      {#each answers as answer (answer.id)}
        <Card className="p-6">
          <div class="flex items-start space-x-4">
            <!-- Vote Section -->
            <div class="flex flex-col items-center space-y-2">
              <button
                class="p-1 rounded hover:bg-accent text-muted-foreground"
                aria-label="추천"
              >
                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M7.41 15.41L12 10.83l4.59 4.58L18 14l-6-6-6 6z" />
                </svg>
              </button>
              <span class="text-lg font-medium">{answer.votes}</span>
              <button
                class="p-1 rounded hover:bg-accent text-muted-foreground"
                aria-label="비추천"
              >
                <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6z" />
                </svg>
              </button>
              {#if answer.isAccepted}
                <div
                  class="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center"
                  title="채택된 답변"
                >
                  <svg
                    class="w-5 h-5 text-green-600"
                    fill="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"
                    />
                  </svg>
                </div>
              {/if}
            </div>

            <!-- Content -->
            <div class="flex-1">
              <div class="prose max-w-none mb-4">
                {#each answer.content.split("\n") as paragraph}
                  {#if paragraph.startsWith("```")}
                    <pre
                      class="bg-muted p-3 rounded text-sm overflow-x-auto"><code
                        >{paragraph
                          .replace(/```\w*\n?/, "")
                          .replace(/```$/, "")}</code
                      ></pre>
                  {:else if paragraph.trim()}
                    <p class="mb-3">{paragraph}</p>
                  {/if}
                {/each}
              </div>

              <!-- Author and Meta -->
              <div
                class="flex items-center justify-between text-sm text-muted-foreground"
              >
                <span>{formatRelativeTime(answer.createdAt)}에 답변됨</span>
                <div class="flex items-center space-x-2">
                  <div
                    class="w-8 h-8 bg-primary/10 rounded-full flex items-center justify-center"
                  >
                    <span class="text-sm font-medium text-primary">
                      {answer.author.charAt(0).toUpperCase()}
                    </span>
                  </div>
                  <div>
                    <div class="font-medium text-foreground">
                      {answer.author}
                    </div>
                    <div class="text-xs">평판 {answer.authorReputation}</div>
                  </div>
                </div>
              </div>

              <!-- Comments Section -->
              {#if answer.comments && answer.comments.length > 0}
                <div class="mt-4 space-y-2 border-t border-border pt-4">
                  {#each answer.comments as comment (comment.id)}
                    <div class="flex items-start space-x-2 text-sm">
                      <div class="flex-1 bg-muted/50 rounded px-3 py-2">
                        <span class="text-foreground">{comment.content}</span>
                        <span class="text-muted-foreground mx-2">–</span>
                        <button
                          class="text-primary hover:underline font-medium"
                          on:click={() => handleNavigate("profile")}
                        >
                          {comment.author}
                        </button>
                        <span class="text-muted-foreground text-xs ml-2">
                          {formatRelativeTime(comment.createdAt)}
                        </span>
                      </div>
                    </div>
                  {/each}
                </div>
              {/if}

              <!-- Add Comment Button -->
              <div class="mt-3">
                <button
                  class="text-sm text-muted-foreground hover:text-primary"
                  on:click={() => toggleCommentForm(answer.id)}
                >
                  댓글 추가
                </button>
              </div>

              <!-- Comment Form -->
              {#if showCommentForm[answer.id]}
                <div class="mt-3 flex items-start space-x-2">
                  <input
                    type="text"
                    bind:value={newCommentContent[answer.id]}
                    placeholder="댓글을 입력하세요..."
                    class="flex-1 px-3 py-2 text-sm border border-input rounded-md bg-background focus:outline-none focus:ring-2 focus:ring-ring"
                    on:keydown={(e) => {
                      if (e.key === 'Enter') {
                        handleSubmitComment(answer.id);
                      }
                    }}
                  />
                  <Button
                    size="sm"
                    on:click={() => handleSubmitComment(answer.id)}
                  >
                    등록
                  </Button>
                  <Button
                    size="sm"
                    variant="ghost"
                    on:click={() => {
                      showCommentForm[answer.id] = false;
                      newCommentContent[answer.id] = "";
                    }}
                  >
                    취소
                  </Button>
                </div>
              {/if}
            </div>
          </div>
        </Card>
      {/each}
    </div>

    <!-- Answer Form -->
    <Card className="p-6">
      <h3 class="text-lg font-semibold mb-4">답변 작성</h3>
      {#if currentUser}
        <div class="space-y-4">
          <textarea
            bind:value={newAnswerContent}
            placeholder="답변을 작성해주세요..."
            class="w-full h-32 p-3 border border-input rounded-md bg-background resize-none focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent"
          ></textarea>
          <div class="flex justify-end">
            <Button on:click={handleSubmitAnswer}>답변 등록</Button>
          </div>
        </div>
      {:else}
        <div class="text-center py-8">
          <p class="text-muted-foreground mb-4">
            답변을 작성하려면 로그인이 필요합니다.
          </p>
          <Button on:click={() => handleNavigate("login")}>로그인</Button>
        </div>
      {/if}
    </Card>
  </div>
</main>
