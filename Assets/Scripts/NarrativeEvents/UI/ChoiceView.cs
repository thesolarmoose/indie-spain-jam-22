using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using ModelView;
using NarrativeEvents.Data;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace NarrativeEvents.UI
{
    public class ChoiceView : ViewBaseBehaviour<(int, Choice, List<Consequence>)>
    {
        [SerializeField] private TextMeshProUGUI _descriptionText;
        [SerializeField] private TextMeshProUGUI _indexText;
        [SerializeField] private Button _button;

        private List<Consequence> _consequence;
        
        public override bool CanRenderModel((int, Choice, List<Consequence>) model)
        {
            return true;
        }

        public override void Initialize((int, Choice, List<Consequence>) model)
        {
            UpdateView(model);
        }

        public override async void UpdateView((int, Choice, List<Consequence>) model)
        {
            var (index, choice, consequence) = model;
            _consequence = consequence;
            _indexText.text = $"{index + 1}";
            var task = choice.Description.GetLocalizedStringAsync().Task;
            var text = await task;
            _descriptionText.text = text;
            UpdateParentLayout();
        }

        private async void UpdateParentLayout()
        {
            await Task.Delay(200);
            var parent = transform.parent;
            var layout = parent.GetComponent<LayoutGroup>();
            var rectTransform = parent.GetComponent<RectTransform>();
            layout.enabled = false;
            layout.CalculateLayoutInputHorizontal();
            layout.CalculateLayoutInputHorizontal();
            LayoutRebuilder.ForceRebuildLayoutImmediate(rectTransform);
            LayoutRebuilder.MarkLayoutForRebuild(rectTransform);
            layout.enabled = true;
        }

        public async Task<List<Consequence>> WaitPressChoice(CancellationToken ct)
        {
            await AsyncUtils.Utils.WaitPressButtonAsync(_button, ct);
            return _consequence;
        }
    }
}