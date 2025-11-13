<script>
  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  const faqs = [
    {
      category: "시작하기",
      questions: [
        {
          q: "Semicolon은 무엇인가요?",
          a: "Semicolon은 개발자들이 기술적인 질문과 답변을 공유하는 커뮤니티 플랫폼입니다. 프로그래밍, 개발 도구, 알고리즘 등 다양한 주제에 대해 토론할 수 있습니다.",
        },
        {
          q: "어떻게 회원가입하나요?",
          a: "우측 상단의 '회원가입' 버튼을 클릭하여 이메일과 비밀번호를 입력하면 간단하게 가입할 수 있습니다.",
        },
        {
          q: "무료로 이용할 수 있나요?",
          a: "네, Semicolon의 모든 기능은 완전 무료로 제공됩니다.",
        },
      ],
    },
    {
      category: "질문하기",
      questions: [
        {
          q: "어떻게 질문을 작성하나요?",
          a: "로그인 후 우측 상단의 '질문하기' 버튼을 클릭하세요. 제목, 본문, 관련 태그를 입력하고 게시하면 됩니다.",
        },
        {
          q: "질문을 수정하거나 삭제할 수 있나요?",
          a: "네, 본인이 작성한 질문은 언제든지 수정하거나 삭제할 수 있습니다. 질문 페이지에서 수정/삭제 버튼을 이용하세요.",
        },
        {
          q: "답변을 어떻게 채택하나요?",
          a: "본인의 질문에 달린 답변 중 가장 도움이 된 답변의 채택 버튼(체크 마크)을 클릭하세요.",
        },
      ],
    },
    {
      category: "답변하기",
      questions: [
        {
          q: "답변을 작성하려면 어떻게 해야 하나요?",
          a: "질문 페이지 하단의 답변 작성 영역에서 답변을 작성하고 '답변 게시' 버튼을 클릭하세요.",
        },
        {
          q: "답변에 코드를 포함할 수 있나요?",
          a: "네, 마크다운 문법을 사용하여 코드 블록을 작성할 수 있습니다. 백틱(```)을 사용하여 코드를 감싸주세요.",
        },
      ],
    },
    {
      category: "평판과 권한",
      questions: [
        {
          q: "평판은 어떻게 쌓이나요?",
          a: "좋은 질문과 답변을 작성하면 다른 사용자들의 투표를 받아 평판을 얻을 수 있습니다. 질문이나 답변이 채택되면 추가 평판을 받습니다.",
        },
        {
          q: "평판이 높으면 어떤 혜택이 있나요?",
          a: "평판이 높을수록 더 많은 권한을 얻습니다. 예를 들어, 다른 사용자의 게시물을 수정하거나 태그를 관리하는 등의 권한이 주어집니다.",
        },
        {
          q: "투표는 어떻게 하나요?",
          a: "질문이나 답변 옆의 화살표 버튼을 클릭하여 긍정 투표(▲) 또는 부정 투표(▼)를 할 수 있습니다.",
        },
      ],
    },
    {
      category: "태그",
      questions: [
        {
          q: "태그는 무엇인가요?",
          a: "태그는 질문을 분류하는 키워드입니다. 프로그래밍 언어, 프레임워크, 주제 등을 나타냅니다.",
        },
        {
          q: "새로운 태그를 만들 수 있나요?",
          a: "네, 질문 작성 시 존재하지 않는 태그를 입력하면 자동으로 새로운 태그가 생성됩니다.",
        },
      ],
    },
  ];

  let expandedIndex = {};

  function toggleFaq(categoryIndex, questionIndex) {
    const key = `${categoryIndex}-${questionIndex}`;
    expandedIndex[key] = !expandedIndex[key];
    expandedIndex = expandedIndex; // trigger reactivity
  }
</script>

<main class="flex-1 p-6 overflow-y-auto">
  <div class="max-w-4xl mx-auto">
    <div class="mb-8">
      <h1 class="text-4xl font-bold mb-4">도움말</h1>
      <p class="text-lg text-muted-foreground mb-6">
        Semicolon 사용에 대한 자주 묻는 질문과 답변입니다.
      </p>

      <!-- Quick Links -->
      <div class="grid grid-cols-2 md:grid-cols-4 gap-3 mb-8">
        <button
          class="p-3 bg-card rounded-lg border hover:border-primary transition-colors text-sm"
          on:click={() => dispatch("navigate", { page: "guidelines" })}
        >
          📋 가이드라인
        </button>
        <button
          class="p-3 bg-card rounded-lg border hover:border-primary transition-colors text-sm"
          on:click={() => dispatch("navigate", { page: "questions" })}
        >
          💬 질문하기
        </button>
        <button
          class="p-3 bg-card rounded-lg border hover:border-primary transition-colors text-sm"
          on:click={() => dispatch("navigate", { page: "tags" })}
        >
          🏷️ 태그 보기
        </button>
        <button
          class="p-3 bg-card rounded-lg border hover:border-primary transition-colors text-sm"
          on:click={() => dispatch("navigate", { page: "users" })}
        >
          👥 사용자
        </button>
      </div>
    </div>

    <!-- FAQ Sections -->
    <div class="space-y-8">
      {#each faqs as category, categoryIndex (category.category)}
        <div>
          <h2 class="text-2xl font-bold mb-4 flex items-center gap-2">
            <span class="w-2 h-8 bg-primary rounded"></span>
            {category.category}
          </h2>
          <div class="space-y-3">
            {#each category.questions as faq, questionIndex (faq.q)}
              {@const key = `${categoryIndex}-${questionIndex}`}
              <div class="bg-card rounded-lg border overflow-hidden">
                <button
                  class="w-full p-4 text-left hover:bg-accent transition-colors flex items-center justify-between gap-4"
                  on:click={() => toggleFaq(categoryIndex, questionIndex)}
                >
                  <span class="font-semibold">{faq.q}</span>
                  <svg
                    class="w-5 h-5 flex-shrink-0 transition-transform {expandedIndex[
                      key
                    ]
                      ? 'rotate-180'
                      : ''}"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M19 9l-7 7-7-7"
                    />
                  </svg>
                </button>
                {#if expandedIndex[key]}
                  <div class="px-4 pb-4 text-muted-foreground border-t pt-4">
                    {faq.a}
                  </div>
                {/if}
              </div>
            {/each}
          </div>
        </div>
      {/each}
    </div>

    <!-- Contact Section -->
    <div class="mt-12 p-6 bg-primary/10 rounded-lg border border-primary">
      <h3 class="text-xl font-bold mb-3">답변을 찾지 못하셨나요?</h3>
      <p class="text-muted-foreground mb-4">
        추가 질문이 있으시면 커뮤니티에 질문을 올려주세요. 다른 사용자들이 도와드릴
        것입니다.
      </p>
      <button
        class="px-4 py-2 bg-primary text-primary-foreground rounded-md hover:bg-primary/90 transition-colors"
        on:click={() => dispatch("navigate", { page: "questions" })}
      >
        질문하러 가기
      </button>
    </div>
  </div>
</main>
