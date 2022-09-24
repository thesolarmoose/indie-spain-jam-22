using System;
using System.Collections.Generic;
using NarrativeEvents.UI;
using TNRD;
using UnityEngine;
using UnityEngine.Localization;
using Utils.Serializables;

namespace NarrativeEvents.Data
{
    [CreateAssetMenu(fileName = "Event", menuName = "Events/Event", order = 0)]
    public class Event : ScriptableObject
    {
        [SerializeField] private LocalizedString _description;
        [SerializeField] private List<ConditionChoiceConsequencesTuple> _choices;

        public LocalizedString Description
        {
            get => _description;
#if UNITY_EDITOR
            set => _description = value;
#endif
        }

#if UNITY_EDITOR
        public List<ConditionChoiceConsequencesTuple> Choices
        {
            get => _choices;
        }

        [ContextMenu("Display", true)]
        private bool CanDisplay()
        {
            return Application.isPlaying;
        }
        
        [ContextMenu("Display")]
        private void DisplayEvent()
        {
            var popup = FindObjectOfType<EventPopup>();
            if (popup != null)
            {
                popup.Initialize(this);
                return;
            }

            var displayer = FindObjectOfType<EventDisplayer>();
            if (displayer != null)
            {
                displayer.DisplayEvent(this);
            }
        }
#endif

        public List<ConditionChoiceConsequencesTuple> GetAvailableChoices()
        {
            return _choices.FindAll(choice => choice.Requirement == null || choice.Requirement.IsMet());
        }
    }

    [Serializable]
    public class ConditionChoiceConsequencesTuple
    {
        [SerializeField] private SerializableInterface<ISerializablePredicate> _requirement;
        [SerializeField] private Choice _choice;
        [SerializeField] private List<Consequence> _consequences;

        public ISerializablePredicate Requirement => _requirement.Value;

        public Choice Choice => _choice;

        public List<Consequence> Consequences => _consequences;

        public ConditionChoiceConsequencesTuple(Choice choice, List<Consequence> consequences)
        {
            _choice = choice;
            _consequences = consequences;
        }
        
        public void UpdateChoiceConsequences(Choice choice, List<Consequence> consequences)
        {
            _choice = choice;
            _consequences = consequences;
        }
    }
}