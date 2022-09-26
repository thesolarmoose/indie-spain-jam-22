using System;
using TMPro;
using UnityAtoms.BaseAtoms;
using UnityEngine;

namespace UI
{
    public class CrewUi : MonoBehaviour
    {
        [SerializeField] private IntVariable _crewVariable;
        [SerializeField] private IntConstant _initialValue;
        [SerializeField] private IntConstant _maxCrewVariable;
        [SerializeField] private TextMeshProUGUI _crewText;

        private void Start()
        {
            _crewVariable.Value = _initialValue.Value;
        }

        private void OnEnable()
        {
            _crewVariable.Changed.Register(OnCrewChanged);
        }

        private void OnDisable()
        {
            _crewVariable.Changed.Unregister(OnCrewChanged);
        }

        private void OnCrewChanged(int crew)
        {
            _crewText.text = $"{_crewVariable.Value}/{_maxCrewVariable.Value}";
        }
    }
}