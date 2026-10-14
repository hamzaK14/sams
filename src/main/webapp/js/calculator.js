/**
 * Requirement 4: Interactive What-If Attendance Calculator using Vanilla JS DOM
 * Viva Tip: Explain that this runs 100% on the client browser using document.getElementById()
 * so it doesn't need to reload the page or query the database every time the student tests a scenario.
 */
function simulateAttendance() {
    // 1. Read selected subject's current stats from the dropdown's data attributes
    const selectElem = document.getElementById("calcSubjectSelect");
    if (!selectElem || selectElem.selectedIndex < 0) return;
    const selectedOption = selectElem.options[selectElem.selectedIndex];
    if (!selectedOption) return;

    const currentAttended = parseInt(selectedOption.getAttribute("data-attended")) || 0;
    const currentTotal = parseInt(selectedOption.getAttribute("data-total")) || 0;

    // 2. Read user input for future classes to attend or skip
    const futureAttend = parseInt(document.getElementById("futureAttendInput").value) || 0;
    const futureSkip = parseInt(document.getElementById("futureSkipInput").value) || 0;
    const resultBox = document.getElementById("simulationResult");

    if (futureAttend < 0 || futureSkip < 0) {
        resultBox.innerHTML = "<span style='color:red;'>Please enter positive numbers only!</span>";
        return;
    }

    // 3. Calculate projected totals and new percentage
    const newAttended = currentAttended + futureAttend;
    const newTotal = currentTotal + futureAttend + futureSkip;
    let projectedPercentage = 100.0;

    if (newTotal > 0) {
        projectedPercentage = ((newAttended / newTotal) * 100).toFixed(2);
    }

    // 4. Determine new Risk Badge color
    let badgeClass = "badge-RED";
    let statusText = "CRITICAL RISK (Below 65%)";

    if (projectedPercentage >= 75.0) {
        badgeClass = "badge-GREEN";
        statusText = "SAFE ZONE (>= 75%)";
    } else if (projectedPercentage >= 65.0) {
        badgeClass = "badge-YELLOW";
        statusText = "WARNING ZONE (65% - 74.9%)";
    }

    // 5. Update the DOM dynamically
    resultBox.innerHTML = `
        <p style="margin-top:15px; font-size:1.05rem;">
            <strong>Projected Attendance:</strong> ${newAttended} / ${newTotal} classes 
            (<strong>${projectedPercentage}%</strong>) &nbsp; 
            <span class="badge ${badgeClass}">${statusText}</span>
        </p>
    `;
}
