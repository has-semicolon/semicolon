<script>
  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  let title = "";
  let content = "";
  let tags = "";
  let isSubmitting = false;

  function handleCancel() {
    dispatch("cancel");
  }

  async function handleSubmit() {
    // 유효성 검사
    if (!title.trim()) {
      alert("제목을 입력해주세요.");
      return;
    }
    if (!content.trim()) {
      alert("내용을 입력해주세요.");
      return;
    }

    isSubmitting = true;

    try {
      // 태그를 배열로 변환 (쉼표나 공백으로 구분)
      const tagArray = tags
        .split(/[,\s]+/)
        .map((tag) => tag.trim())
        .filter((tag) => tag.length > 0);

      const questionData = {
        title: title.trim(),
        content: content.trim(),
        tags: tagArray,
      };

      // TODO: 나중에 백엔드 연결 시
      // POST /api/v1/questions/
      // Body: { title, content, tags }
      // Headers: { Authorization: Bearer <token> }

      console.log("질문 데이터:", questionData);

      // 임시: 성공 메시지
      alert("질문이 작성되었습니다!");
      dispatch("submit", questionData);
    } catch (error) {
      console.error("질문 작성 실패:", error);
      alert("질문 작성에 실패했습니다. 다시 시도해주세요.");
    } finally {
      isSubmitting = false;
    }
  }
</script>

<div class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
  <div class="bg-background rounded-lg shadow-xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
    <div class="sticky top-0 bg-background border-b p-6">
      <h2 class="text-2xl font-bold">질문하기</h2>
      <p class="text-sm text-muted-foreground mt-1">
        커뮤니티에 질문을 올려보세요. 다른 개발자들이 도와드릴 거예요!
      </p>
    </div>

    <form on:submit|preventDefault={handleSubmit} class="p-6 space-y-6">
      <!-- 제목 -->
      <div>
        <label for="title" class="block text-sm font-medium mb-2">
          제목 <span class="text-red-500">*</span>
        </label>
        <input
          id="title"
          type="text"
          bind:value={title}
          placeholder="질문의 핵심을 간단명료하게 작성해주세요"
          class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary"
          maxlength="200"
          required
        />
        <p class="text-xs text-muted-foreground mt-1">
          {title.length}/200
        </p>
      </div>

      <!-- 내용 -->
      <div>
        <label for="content" class="block text-sm font-medium mb-2">
          내용 <span class="text-red-500">*</span>
        </label>
        <textarea
          id="content"
          bind:value={content}
          placeholder="문제 상황, 시도해본 방법, 기대하는 결과 등을 자세히 설명해주세요.&#10;&#10;코드를 포함할 경우 백틱(```)을 사용하여 코드 블록으로 감싸주세요."
          class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary min-h-[300px] resize-y"
          required
        ></textarea>
        <p class="text-xs text-muted-foreground mt-1">
          마크다운 형식을 지원합니다.
        </p>
      </div>

      <!-- 태그 -->
      <div>
        <label for="tags" class="block text-sm font-medium mb-2">
          태그
        </label>
        <input
          id="tags"
          type="text"
          bind:value={tags}
          placeholder="javascript, react, typescript (쉼표 또는 공백으로 구분)"
          class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-primary"
        />
        <p class="text-xs text-muted-foreground mt-1">
          질문과 관련된 기술, 언어, 프레임워크 등을 태그로 추가하세요.
        </p>
      </div>

      <!-- 작성 가이드 -->
      <div class="p-4 bg-muted rounded-lg">
        <h3 class="text-sm font-semibold mb-2">💡 좋은 질문을 위한 팁</h3>
        <ul class="text-sm text-muted-foreground space-y-1">
          <li>• 제목은 문제의 핵심을 명확하게 표현하세요</li>
          <li>• 문제 상황, 기대하는 결과, 실제 결과를 구분하여 작성하세요</li>
          <li>• 관련 코드는 최소한으로 줄여서 포함하세요</li>
          <li>• 에러 메시지가 있다면 전체 내용을 포함하세요</li>
          <li>• 시도해본 해결 방법들을 공유하세요</li>
        </ul>
      </div>

      <!-- 버튼 -->
      <div class="flex gap-3 justify-end pt-4 border-t">
        <button
          type="button"
          on:click={handleCancel}
          class="px-4 py-2 border rounded-md hover:bg-accent transition-colors"
          disabled={isSubmitting}
        >
          취소
        </button>
        <button
          type="submit"
          class="px-4 py-2 bg-primary text-primary-foreground rounded-md hover:bg-primary/90 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          disabled={isSubmitting}
        >
          {isSubmitting ? "작성 중..." : "질문 올리기"}
        </button>
      </div>
    </form>
  </div>
</div>

<style>
  /* 스크롤바 스타일링 */
  textarea::-webkit-scrollbar {
    width: 8px;
  }

  textarea::-webkit-scrollbar-track {
    background: transparent;
  }

  textarea::-webkit-scrollbar-thumb {
    background: #cbd5e0;
    border-radius: 4px;
  }

  textarea::-webkit-scrollbar-thumb:hover {
    background: #a0aec0;
  }
</style>
