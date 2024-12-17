let isExpanded = false;

function toggleProjects() {
    const projectList = document.getElementById('my-projects');
    const toggleBtn = document.querySelector('.toggle-btn');

    if (isExpanded) {
        // Collapse the list
        projectList.classList.remove('expanded');
        toggleBtn.textContent = '펼치기';
    } else {
        // Expand the list
        projectList.classList.add('expanded');
        toggleBtn.textContent = '접기';
    }

    isExpanded = !isExpanded;
}
