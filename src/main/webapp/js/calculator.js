/**
 * SAMS — Theme 7: Swiss Grid What-If & Required Attendance Calculator
 */
function simulateAttendance() {
    const selectElem = document.getElementById("calcSubjectSelect");
    if (!selectElem || selectElem.options.length === 0) return;

    const selectedOption = selectElem.options[selectElem.selectedIndex];
    const currentAttended = parseInt(selectedOption.getAttribute("data-attended")) || 0;
    const currentTotal = parseInt(selectedOption.getAttribute("data-total")) || 0;

    const futureAttend = parseInt(document.getElementById("futureAttendInput").value) || 0;
    const futureSkip = parseInt(document.getElementById("futureSkipInput").value) || 0;
    const resultBox = document.getElementById("simulationResult");

    if (futureAttend < 0 || futureSkip < 0) {
        resultBox.innerHTML = `<div class="alert">Please enter 0 or positive numbers only.</div>`;
        return;
    }

    const newAttended = currentAttended + futureAttend;
    const newTotal = currentTotal + futureAttend + futureSkip;

    let projectedPct = 100;
    if (newTotal > 0) {
        projectedPct = Math.round((newAttended / newTotal) * 100);
    }

    // Calculate consecutive classes needed if projected percentage is still below 75%
    let neededFor75 = 0;
    if (projectedPct < 75 && newTotal > 0) {
        neededFor75 = Math.ceil(((0.75 * newTotal) - newAttended) / 0.25);
        if (neededFor75 < 0) neededFor75 = 0;
    }

    const statusClass = projectedPct >= 75 ? "ok" : (projectedPct >= 65 ? "warn" : "bad");
    const statusLabel = projectedPct >= 75
        ? "Safe — At or above 75% target."
        : `Below 75%. Need ${neededFor75} consecutive lectures after this to reach 75%.`;

    resultBox.innerHTML = `
        <div class="stats" style="grid-template-columns: repeat(2, 1fr); margin: 0 0 12px;">
            <div style="border-top: 0; padding-top: 0;">
                <b class="${statusClass}">${projectedPct}%</b>
                <span>Projected attendance (${newAttended}/${newTotal} lectures)</span>
            </div>
            <div style="border-top: 0; padding-top: 0;">
                <b>${neededFor75}</b>
                <span>Consecutive lectures needed for 75%</span>
            </div>
        </div>
        <p class="${statusClass}" style="font-size: 13px;">${statusLabel}</p>
    `;
}