// 프로젝트 유형 선택
document.querySelectorAll(".project-type").forEach(button => {
    button.addEventListener("click", function () {
        document.querySelectorAll(".project-type").forEach(b => b.classList.remove("selected"));
        this.classList.add("selected");
        document.getElementById("project_type").value = this.dataset.value;
    });
});

// 기술 스택 추가
function addField() {
    const inputField = document.getElementById("field-input");
    const fieldValue = inputField.value.trim();

    if (fieldValue) {
        const tagItem = document.createElement("div");
        tagItem.classList.add("tag-item");

        const tagName = document.createElement("span");
        tagName.textContent = fieldValue;

        const deleteButton = document.createElement("button");
        deleteButton.innerHTML = "&times;";
        deleteButton.classList.add("delete-btn");
        deleteButton.onclick = function () {
            tagItem.remove();
            updateTechStackInput();
        };

        tagItem.appendChild(tagName);
        tagItem.appendChild(deleteButton);
        document.getElementById("field-list").appendChild(tagItem);
        inputField.value = '';
        updateTechStackInput();
    } else {
        alert("내용을 입력해주세요!");
    }
}

function useExampleTag(value) {
    const inputField = document.getElementById("field-input");
    inputField.value = value;
    addField();
}

// 기술 스택 숨김 필드 업데이트
function updateTechStackInput() {
    const tags = document.querySelectorAll("#field-list .tag-item span");
    const techStackInput = document.getElementById("techStackInput");
    techStackInput.value = Array.from(tags).map(tag => tag.textContent).join(",");
}

// 모집 분야 추가
let recruitmentCounter = 1;
function addRecruitment() {
    recruitmentCounter++;
    const recruitmentList = document.getElementById("recruitment-list");

    const newRecruitment = document.createElement("div");
    newRecruitment.className = "recruitment-item";
    newRecruitment.innerHTML = `
        <h3 class="recruitment-title">모집 분야 #${recruitmentCounter}</h3>
        <div class="recruitment-fields">
            <input type="text" name="recruit_field[]" placeholder="역할 (예: AI 개발자)" required>
            <input type="number" name="recruit_count[]" value="1" min="1" required> 명
        </div>
        <textarea name="recruit_requirements[]" rows="2" placeholder="필요 역량이나 요구사항" required></textarea>
        <button type="button" class="delete-btn" onclick="deleteRecruitment(this)">삭제</button>
    `;
    recruitmentList.appendChild(newRecruitment);
}

// 모집 분야 삭제 (최소 1개 유지)
function deleteRecruitment(button) {
    const recruitmentList = document.getElementById("recruitment-list");
    const recruitmentItems = recruitmentList.querySelectorAll(".recruitment-item");

    // 삭제 전에 최소 한 개의 항목이 남아있도록 확인
    if (recruitmentItems.length > 1) {
        const recruitmentItem = button.parentElement;
        recruitmentItem.remove();

        // 순서 다시 업데이트
        const remainingItems = recruitmentList.querySelectorAll(".recruitment-item");
        recruitmentCounter = remainingItems.length;
        remainingItems.forEach((item, index) => {
            item.querySelector(".recruitment-title").textContent = `모집 분야 #${index + 1}`;
        });
    } else {
        alert("모집 분야는 최소 한 개 이상 필요합니다.");
    }
}

// 유효성 검사
function validateForm() {
    const projectType = document.querySelector("#project_type").value;
    if (!projectType) {
        alert("프로젝트 유형을 선택해주세요.");
        return false;
    }
    const tags = document.querySelectorAll("#field-list .tag-item");
    if (tags.length === 0) {
        alert("기술 스택을 최소 1개 이상 추가해주세요.");
        return false;
    }
    return true;
}
